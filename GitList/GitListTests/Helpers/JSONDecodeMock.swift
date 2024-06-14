//
//  JSONDecodeMock.swift
//  GitListTests
//
//  Created by Elen Souza on 13/06/24.
//

import Foundation
@testable import GitList

final class JSONDecoderMock: JSONDecoderProtocol {
    private(set) var decodeCounts = 0
    private(set) var types: [Any] = []
    private(set) var datas: [Data] = []

    var keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .convertFromSnakeCase

    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable {
        decodeCounts += 1
        types.append(type)
        datas.append(data)

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = keyDecodingStrategy
        return try decoder.decode(type, from: data)
    }
}
