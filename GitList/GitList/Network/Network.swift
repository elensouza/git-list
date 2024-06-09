//
//  Network.swift
//  GitList
//
//  Created by Elen Souza on 09/06/24.
//

import Foundation

protocol URLSessionProtocol {
    func task(with request: URLRequest,
              completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol
}

protocol URLSessionDataTaskProtocol {
    func resume()
}

extension URLSession: URLSessionProtocol {
    func task(with request: URLRequest,
              completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        dataTask(with: request, completionHandler: completionHandler)
    }
}

extension URLSessionDataTask: URLSessionDataTaskProtocol { }

final class Network {
    enum CustomError: Error {
        case invalidUrl
        case invalidData
        case decode
        case noConnection
    }

    private let urlSession: URLSessionProtocol
    private let decoder: JSONDecoderProtocol

    init(urlSession: URLSessionProtocol = URLSession.shared,
         decoder: JSONDecoderProtocol = JSONDecoder()) {
        self.urlSession = urlSession
        self.decoder = decoder
    }

    func request<T>(path: String,
                    params: [String: String?] = [:],
                    expecting: T.Type = T.self,
                    completion: @escaping (Result<T, Error>) -> Void) where T: Decodable {
        guard let scheme: String = try? Configuration.value(for: .scheme),
              let host: String = try? Configuration.value(for: .host),
              let beginPath: String = try? Configuration.value(for: .beginPath) else {
            return completion(.failure(CustomError.invalidUrl))
        }

        var urlComponent = URLComponents()
        urlComponent.scheme = scheme
        urlComponent.host = host
        urlComponent.path = beginPath + path
        urlComponent.queryItems = params.map { param in
            URLQueryItem(name: param.key, value: param.value)
        }

        guard let url = urlComponent.url else {
            return completion(.failure(CustomError.invalidUrl))
        }

        let urlRequest = URLRequest(url: url)
        urlSession.task(with: urlRequest) { [weak self] data, _, error  in
            if let error = error {
                self?.handleError(error, completion: completion)
                return
            }

            guard let data = data else {
                self?.sendResponse(result: .failure(CustomError.invalidData), completion: completion)
                return
            }

            self?.handleSuccess(data: data, completion: completion)
        }.resume()
    }

    private func handleError<T: Decodable>(_ error: Error,
                                           completion: @escaping (Result<T, Error>) -> Void) {

        guard (error as NSError?)?.code == NSURLErrorNotConnectedToInternet else {
            sendResponse(result: .failure(error),
                         completion: completion)
            return
        }

        sendResponse(result: .failure(CustomError.noConnection),
                     completion: completion)
    }

    private func handleSuccess<T: Decodable>(data: Data,
                                             completion: @escaping (Result<T, Error>) -> Void) {
        guard let result: T = JSONHelper.decode(data: data, decoder: decoder) else {
            sendResponse(result: .failure(CustomError.decode), completion: completion)
            return
        }

        sendResponse(result: .success(result), completion: completion)
    }

    private func sendResponse<T: Decodable>(result: Result<T, Error>,
                                            completion: @escaping (Result<T, Error>) -> Void) {
        DispatchQueue.main.async {
            completion(result)
        }
    }
}
