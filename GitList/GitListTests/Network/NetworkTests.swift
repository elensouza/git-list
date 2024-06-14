//
//  NetworkTests.swift
//  GitListTests
//
//  Created by Elen Souza on 13/06/24.
//

import Foundation
import XCTest

@testable import GitList

final class NetworkTests: XCTestCase {

    var sessionDataTaskMock: URLSessionDataTaskMock!
    var urlSession: URLSessionMock!
    var decoder: JSONDecoderMock!
    var sut: Network!

    override func setUp() {
        super.setUp()
        sessionDataTaskMock = URLSessionDataTaskMock()
        urlSession = URLSessionMock(sessionDataTaskMock: sessionDataTaskMock)
        decoder = JSONDecoderMock()
        sut = Network(urlSession: urlSession, decoder: decoder)
    }

    override func tearDown() {
        super.tearDown()
        sessionDataTaskMock = nil
        urlSession = nil
        decoder = nil
        sut = nil
    }

    func test_success() {
        let expectation = self.expectation(description: "Wait for url to load.")

        let data = JSONHelper.readLocalJSONFile(forName: "result", bundle: Bundle(for: type(of: self)))
        let model: [GitResponse]? = JSONHelper.getLocalData(fileName: "result", bundle: Bundle(for: type(of: self)))

        urlSession.completionData = data
        urlSession.completionResponse = nil
        urlSession.completionError = nil

        sut.request(path: "") { (result: Result<[GitResponse], Error>) in
            switch result {
            case .success(let response):
                XCTAssertEqual(response, model)
            case .failure(let error):
                XCTFail("Expected success, but got failure with error: \(error.localizedDescription)")
            }

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_failureDecode() {
        let expectation = self.expectation(description: "Wait for url to load.")

        urlSession.completionData = nil
        urlSession.completionResponse = nil
        urlSession.completionError = Network.CustomError.decode

        sut.request(path: "") { (result: Result<String, Error>) in
            switch result {
            case .success:
                XCTFail("Expected failure, but got success")
            case .failure(let error):
                let customError = error as? Network.CustomError
                XCTAssertEqual(customError, .decode)
            }

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }
}

