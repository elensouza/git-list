//
//  JSONHelper.swift
//  GitList
//
//  Created by Elen Souza on 09/06/24.
//

import Foundation

protocol JSONDecoderProtocol {
    var keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy { get set }

    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T: Decodable
}

protocol JSONEncoderProtocol {
    var keyEncodingStrategy: JSONEncoder.KeyEncodingStrategy { get set }

    func encode<T>(_ value: T) throws -> Data where T: Encodable
}

extension JSONDecoder: JSONDecoderProtocol { }

extension JSONEncoder: JSONEncoderProtocol { }

enum JSONHelper {
    static func decode<T: Decodable>(data: Data, decoder: JSONDecoderProtocol = JSONDecoder()) -> T? {
        do {
            var jsonDecoder = decoder
            jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
            let decodedData = try jsonDecoder.decode(T.self, from: data)
            return decodedData
        } catch {
#if DEBUG
            print("error: \(error)")
#endif
            return nil
        }
    }

    static func getLocalData<T: Decodable>(fileName: String, bundle: Bundle = Bundle.main) -> T? {
        guard let jsonData = readLocalJSONFile(forName: fileName, bundle: bundle) else { return nil }
        return decode(data: jsonData)
    }

    static func readLocalJSONFile(forName name: String, bundle: Bundle) -> Data? {
        do {
            if let filePath = bundle.path(forResource: name, ofType: "json") {
                let fileUrl = URL(fileURLWithPath: filePath)
                let data = try Data(contentsOf: fileUrl)
                return data
            }
        } catch {
#if DEBUG
            print("error: \(error)")
#endif
        }
        return nil
    }
}
