//
//  GitListServiceMock.swift
//  GitListTests
//
//  Created by Elen Souza on 13/06/24.
//

import Foundation
import XCTest
@testable import GitList

final class GitListServiceMock: GitListServiceProtocol {
    private(set) var getGitsCalledCount = 0

    var result: Result<[GitResponse], Error>?

    func getGits(params: [String : String?], completion: @escaping (Result<[GitList.GitResponse], Error>) -> Void) {
        guard let result = result else {
            XCTFail("expected result")
            return
        }
        getGitsCalledCount += 1
        completion(result)
    }
}
