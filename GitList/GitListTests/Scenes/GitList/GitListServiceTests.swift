//
//  GitListServiceTests.swift
//  GitListTests
//
//  Created by Elen Souza on 13/06/24.
//

import Foundation
import XCTest
@testable import GitList

final class GitListServiceTests: XCTestCase {
    private var sut: GitListService!
    private var sessionDataTaskMock: URLSessionDataTaskMock!
    private var urlSession: URLSessionMock!
    private var decoder: JSONDecoderMock!

    override func setUpWithError() throws {
        sessionDataTaskMock = URLSessionDataTaskMock()
        urlSession = URLSessionMock(sessionDataTaskMock: sessionDataTaskMock)
        decoder = JSONDecoderMock()
        let network = Network(urlSession: urlSession, decoder: decoder)
        sut = GitListService(network: network)
    }

    override func tearDownWithError() throws {
        sessionDataTaskMock = nil
        urlSession = nil
        decoder = nil
        sut = nil
    }

    func test_getGits_returns_success() {
        // Given
        let data = JSONHelper.readLocalJSONFile(forName: "result", bundle: Bundle(for: type(of: self)))
        let model: [GitResponse]? = JSONHelper.getLocalData(fileName: "result", bundle: Bundle(for: type(of: self)))
        urlSession.completionData = data

        // When
        let expectation = self.expectation(description: "getGits")
        sut.getGits(params: ["page": "0"]) { result in
            // Then
            switch result {
            case .success(let response):
                XCTAssertEqual(response, model)
            case .failure(let error):
                XCTFail("Expected success, but got failure with error: \(error.localizedDescription)")
            }

            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }

    func test_getGit_returns_failureError() {
        // Given
        urlSession.completionError = NSError(domain: "", code: NSURLErrorBadServerResponse, userInfo: nil)

        // When
        let expectation = self.expectation(description: "getGits")
        sut.getGits(params: [:]) { result in
            // Then
            switch result {
            case .success:
                XCTFail("Expected failure, but got success")
            case .failure(let error):
                let nsError = error as NSError
                XCTAssertEqual(nsError.code, NSURLErrorBadServerResponse)
            }

            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }
}
