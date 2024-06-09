//
//  Configuration.swift
//  GitList
//
//  Created by Elen Souza on 09/06/24.
//

import Foundation

enum Configuration {
    enum CustomError: Error {
        case missingKey, invalidValue
    }

    enum Key: String {
        case host = "HOST"
        case scheme = "SCHEME"
        case beginPath = "BEGIN_PATH"
    }

    static func value<T>(for key: Key) throws -> T where T: LosslessStringConvertible {
        guard let object = Bundle.main.object(forInfoDictionaryKey: key.rawValue) else {
            throw CustomError.missingKey
        }

        switch object {
        case let value as T:
            return value
        case let string as String:
            guard let value = T(string) else { fallthrough }
            return value
        default:
            throw CustomError.invalidValue
        }
    }
}
