//
//  URLSessionMock.swift
//  GitListTests
//
//  Created by Elen Souza on 13/06/24.
//

import Foundation
@testable import GitList

final class URLSessionMock: URLSessionProtocol {

    private(set) var sessionDataTaskMock: URLSessionDataTaskProtocol

    init(sessionDataTaskMock: URLSessionDataTaskProtocol) {
        self.sessionDataTaskMock = sessionDataTaskMock
    }

    private(set) var taskCounts = 0
    private(set) var requests: [URLRequest] = []
    private(set) var completionHandlers: [(Data?, URLResponse?, Error?) -> Void] = []

    var completionData: Data?
    var completionResponse: URLResponse?
    var completionError: Error?

    func task(with request: URLRequest,
              completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        taskCounts += 1
        requests.append(request)
        completionHandlers.append(completionHandler)

        completionHandler(completionData, completionResponse, completionError)

        return sessionDataTaskMock
    }
}

final class URLSessionDataTaskMock: URLSessionDataTaskProtocol {
    private(set) var resumeCounts = 0

    func resume() {
        resumeCounts += 1
    }
}
