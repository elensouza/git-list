//
//  GitListViewControllerTests.swift
//  GitListTests
//
//  Created by Elen Souza on 13/06/24.
//

import Foundation
import XCTest
@testable import GitList

final class GitListViewControllerTests: XCTestCase {
    var sut: GitListViewController!
    var presenterSpy: GitListPresenterSpy!

    override func setUp() {
        super.setUp()
        presenterSpy = GitListPresenterSpy()
        sut = GitListViewController(presenter: presenterSpy)
        let navigationController = UINavigationController(rootViewController: sut)
        setupRootViewController(for: navigationController)
    }

    override func tearDown() {
        super.tearDown()
        presenterSpy = nil
        sut = nil
    }

    func test_viewDidLoad() throws  {
        sut.viewDidLoad()

        let naviTitle = sut.navigationItem.title
        let titleStyle = sut.navigationController?.navigationBar.prefersLargeTitles
        let titleMode =  sut.navigationItem.largeTitleDisplayMode

        let emptyListView = try getEmptyListView()
        let indicatorView = try getIndicatorView()
        let tableView = try getTableView()

        XCTAssertEqual(presenterSpy.getGitsCalledCount, 2)
        XCTAssertEqual(naviTitle, "Gits 🐱")
        XCTAssertEqual(titleStyle, true)
        XCTAssertEqual(titleMode, .always)

        XCTAssertEqual(emptyListView.isHidden, true)
        XCTAssertEqual(indicatorView.isAnimating, false)
        XCTAssertEqual((tableView.dataSource?.tableView(tableView,
                                                        numberOfRowsInSection: 0)), 0)
    }
    func test_viewDidLoad_snapshot() {
        presenterSpy.gits = [.stub(photoURL: ""), .stub(photoURL: ""), .stub(photoURL: "")]
        sut.viewDidLoad()
        convenienceSnapshot(matching: sut)
    }

    func test_reloadData() throws {
        presenterSpy.gits = [.stub(), .stub(), .stub()]
        sut.reloadData()
        sut.dismissLoading()

        let emptyListView = try getEmptyListView()
        let indicatorView = try getIndicatorView()

        XCTAssertEqual(emptyListView.isHidden, true)
        XCTAssertEqual(indicatorView.isAnimating, false)
    }

    func test_reloadData_snapshot() {
        presenterSpy.gits = [.stub(photoURL: ""), .stub(photoURL: ""), .stub(photoURL: "")]
        sut.reloadData()
        convenienceSnapshot(matching: sut)
    }

    func test_showLoading() throws {
        sut.showLoading()

        let emptyListView = try getEmptyListView()
        let indicatorView = try getIndicatorView()

        XCTAssertEqual(emptyListView.isHidden, true)
        XCTAssertEqual(indicatorView.isAnimating, true)
    }

    func test_showLoading_snapshot() {
        sut.showLoading()

        convenienceSnapshot(matching: sut)
    }

    func test_dismissLoading() throws {
        sut.dismissLoading()

        let emptyListView = try getEmptyListView()
        let indicatorView = try getIndicatorView()

        XCTAssertEqual(emptyListView.isHidden, true)
        XCTAssertEqual(indicatorView.isAnimating, false)
    }

    func test_showError() {
        sut.viewDidLoad()
        sut.reloadData()
        sut.showError(message: "some error description")

        XCTAssertTrue(sut.presentedViewController is UIAlertController)
    }

    func test_didSelectItemAt() throws {
        presenterSpy.gits = [.stub(), .stub(), .stub()]
        sut.viewDidLoad()

        let tableView = try getTableView()

        tableView.delegate?.tableView?(tableView, didSelectRowAt: IndexPath(row: 1, section: 0))

        XCTAssert(((sut.navigationController?.viewControllers.last?.isKind(of: GitDetailsViewController.self)) != nil))
    }

    func test_willDisplayFooterView() throws {
        presenterSpy.gits = [.stub(), .stub(), .stub()]
        sut.viewDidLoad()
        let tableView = try XCTUnwrap(getTableView())

        tableView.delegate?.tableView?(tableView, willDisplayFooterView: .init(), forSection: 0)

        XCTAssertEqual(presenterSpy.getGitsCalledCount, 3)
        XCTAssertEqual(presenterSpy.currentPage, 1)
    }

    func test_numberOfItemsInSection() throws {
        presenterSpy.gits = [.stub(), .stub(), .stub()]
        sut.viewDidLoad()
        sut.reloadData()

        let tableView = try getTableView()

        XCTAssertEqual(tableView.dataSource?.tableView(tableView, numberOfRowsInSection: 0), 3)
    }

    func test_cellForItem() throws {
        presenterSpy.gits = [.stub(), .stub(), .stub()]
        sut.viewDidLoad()

        let tableView = try getTableView()

        XCTAssert(((tableView.dataSource?.tableView(tableView,
                                                    cellForRowAt: (IndexPath(row: 1, section: 0))).isKind(of: GitTableViewCell.self)) != nil))
    }

    func test_viewForFooterInSection() throws {
        presenterSpy.gits = [.stub(), .stub(), .stub()]
        sut.viewDidLoad()
        let tableView = try XCTUnwrap(getTableView())

        let view = tableView.delegate?.tableView?(tableView, viewForFooterInSection: 0)

        XCTAssert(((view?.isKind(of: LoadingTableViewReusableView.self)) != nil))
    }
    func test_refreshGitList() throws {
        sut.viewDidLoad()

        let tableView = try getTableView()
        let refreshControl = try XCTUnwrap(tableView.refreshControl)

        refreshControl.sendActions(for: .valueChanged)

        XCTAssertEqual(presenterSpy.updateGitsCalledCount, 1)
    }

    private func getIndicatorView() throws -> UIActivityIndicatorView {
        guard let activity = sut.view.subviews.first(where: {
            $0.accessibilityIdentifier == "activityIndicator" }) as? UIActivityIndicatorView else {
            throw AccessibilityIdentifierError.indicatorView
        }
        return activity
    }

    private func getEmptyListView() throws -> UIView {
        guard let emptyListView = sut.view.subviews.first(where: {
            $0.accessibilityIdentifier == "viewEmptyList" }) else {
            throw AccessibilityIdentifierError.emptyView
        }
        return emptyListView
    }

    private func getTableView() throws -> UITableView {
        guard let tableView = sut.view.subviews.first(where: {
            $0.accessibilityIdentifier == "tableView" }) as? UITableView else {
            throw AccessibilityIdentifierError.tableView
        }
        return tableView
    }

    private func setupRootViewController(for navigationController: UINavigationController) {
        if #available(iOS 15.0, *) {
            UIApplication
                .shared
                .connectedScenes
                .compactMap { ($0 as? UIWindowScene)?.keyWindow }
                .last?
                .rootViewController = navigationController
        } else {
            UIApplication
                .shared
                .windows
                .filter {$0.isKeyWindow}
                .last?
                .rootViewController = navigationController
        }
    }

    private enum AccessibilityIdentifierError: Error {
        case indicatorView
        case emptyView
        case tableView
    }
}
