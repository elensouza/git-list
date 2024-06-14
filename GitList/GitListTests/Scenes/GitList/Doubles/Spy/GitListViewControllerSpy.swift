//
//  GitListViewControllerSpy.swift
//  GitListTests
//
//  Created by Elen Souza on 13/06/24.
//

import Foundation
@testable import GitList

final class GitListViewControllerSpy: GitListViewControllerProtocol {
    private(set) var reloadDataCalledCount = 0
    private(set) var showLoadingCalledCount = 0
    private(set) var dismissLoadingCalledCount = 0
    private(set) var showErrorCalled: [String] = []
    private(set) var scrollToTopCalledCount = 0

    func reloadData() {
        reloadDataCalledCount += 1
    }

    func showLoading() {
        showLoadingCalledCount += 1
    }

    func dismissLoading() {
        dismissLoadingCalledCount += 1
    }

    func showError(message: String) {
        showErrorCalled.append(message)
    }

    func scrollToTop() {
        scrollToTopCalledCount += 1
    }
}
