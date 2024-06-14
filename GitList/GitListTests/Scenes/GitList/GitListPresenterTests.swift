//
//  GitListPresenterTests.swift
//  GitListTests
//
//  Created by Elen Souza on 13/06/24.
//

import Foundation
import XCTest
@testable import GitList

final class GitListPresenterTests: XCTestCase {

    var sut: GitListPresenter!
    var controller: GitListViewControllerSpy!
    var serviceMock: GitListServiceMock!

    override func setUp() {
        super.setUp()
        serviceMock = GitListServiceMock()
        controller = GitListViewControllerSpy()
        sut = GitListPresenter(service: serviceMock)
        sut.controller = controller
    }

    override func tearDown() {
        super.tearDown()
        serviceMock = nil
        controller = nil
        sut = nil
    }

    func test_getGits_success() {
        guard let model: [GitResponse] = JSONHelper.getLocalData(fileName: "result",
                                                                       bundle: Bundle(for: type(of: self))) else {
            XCTFail("expected response")
            return
        }
        serviceMock.result = .success(model)
        sut.getGits()
        XCTAssertEqual(sut.gits, GitListAdapter.adaptToGitCellViewModel(model))
        XCTAssertEqual(sut.currentPage, 0)
        XCTAssertEqual(sut.isRequesting, false)

        XCTAssertEqual(serviceMock.getGitsCalledCount, 1)
        XCTAssertEqual(controller.reloadDataCalledCount, 1)
        XCTAssertEqual(controller.showLoadingCalledCount, 1)
        XCTAssertEqual(controller.dismissLoadingCalledCount, 1)
        XCTAssertEqual(controller.showErrorCalled.count, 0)
        XCTAssertEqual(controller.scrollToTopCalledCount, 0)
    }

    func test_getGits_failure() {
        serviceMock.result = .failure(Network.CustomError.noConnection)
        sut.getGits()
        XCTAssert(sut.gits.isEmpty)
        XCTAssertEqual(sut.currentPage, 0)
        XCTAssertEqual(sut.isRequesting, false)

        XCTAssertEqual(serviceMock.getGitsCalledCount, 1)
        XCTAssertEqual(controller.reloadDataCalledCount, 0)
        XCTAssertEqual(controller.showLoadingCalledCount, 1)
        XCTAssertEqual(controller.dismissLoadingCalledCount, 1)
        XCTAssertEqual(controller.showErrorCalled.count, 1)
        XCTAssertEqual(controller.scrollToTopCalledCount, 0)
    }

    func test_updateGits() {
        guard let model: [GitResponse] = JSONHelper.getLocalData(fileName: "result",
                                                                       bundle: Bundle(for: type(of: self))) else {
            XCTFail("expected response")
            return
        }
        serviceMock.result = .success(model)
        sut.updateGits()

        XCTAssertEqual(sut.gits, GitListAdapter.adaptToGitCellViewModel(model))
        XCTAssertEqual(sut.currentPage, 0)
        XCTAssertEqual(sut.isRequesting, false)

        XCTAssertEqual(serviceMock.getGitsCalledCount, 1)
        XCTAssertEqual(controller.reloadDataCalledCount, 1)
        XCTAssertEqual(controller.showLoadingCalledCount, 1)
        XCTAssertEqual(controller.dismissLoadingCalledCount, 1)
        XCTAssertEqual(controller.showErrorCalled.count, 0)
        XCTAssertEqual(controller.scrollToTopCalledCount, 0)
    }

    func testUpdatePage() {
        sut.updatePage()
        XCTAssertEqual(sut.currentPage, 1)
    }
}
