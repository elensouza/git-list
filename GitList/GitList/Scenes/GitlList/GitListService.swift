//
//  GitListService.swift
//  GitList
//
//  Created by Elen Souza on 09/06/24.
//

import Foundation

protocol GitListServiceProtocol {
    func getGits(params: [String: String?],
                       completion: @escaping (Result<[GitResponse], Error>) -> Void)
}

final class GitListService: GitListServiceProtocol {

    enum Constants {
        static let gists: String = "/gists/public"
    }

    private let network: Network

    init(network: Network = Network()) {
        self.network = network
    }

    func getGits(params: [String: String?],
                       completion: @escaping (Result<[GitResponse], Error>) -> Void) {
        network.request(path: Constants.gists,
                        params: params,
                        expecting: [GitResponse].self) { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                return completion(.failure(error))
            }
        }
    }
}
