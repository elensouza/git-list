//
//  GitDetailsViewControllerTests.swift
//  GitListTests
//
//  Created by Elen Souza on 13/06/24.
//

import Foundation
import XCTest
@testable import GitList

final class GitDetailsViewControllerTests: XCTestCase {
    var sut: GitDetailsViewController!

    override func setUp() {
        super.setUp()
        sut = GitDetailsViewController(viewModel: .stub(photoURL: ""))
    }

    override func tearDown() {
        super.tearDown()
        sut = nil
    }

    func test_viewDidLoad() {
        sut.viewDidLoad()
        let naviTitle = sut.navigationItem.title
        let titleMode =  sut.navigationItem.largeTitleDisplayMode

        XCTAssertEqual(naviTitle, "Detalhes")
        XCTAssertEqual(titleMode, .always)
    }

    func test_viewDidLoad_snapshot() {
        sut.viewDidLoad()
        convenienceSnapshot(matching: sut)
    }
}
