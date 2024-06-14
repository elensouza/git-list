//
//  GitTableViewCellTests.swift
//  GitListTests
//
//  Created by Elen Souza on 13/06/24.
//

import Foundation
import XCTest
import SnapshotTesting

@testable import GitList

final class GitTableViewCellSnapshotTests: XCTestCase {
    var sut: GitTableViewCell!

    override func setUp() {
        super.setUp()
        sut = GitTableViewCell()
        sut.frame = CGRect(x: 0, y: 0, width: 360, height: 70)
    }

    override func tearDown() {
        sut = nil
    }

    func testPrepareForReuse() {
        sut.prepareForReuse()
        convenienceSnapshot(matching: sut)
    }

    func testSetup() {
        sut.setup(with: .stub(photoURL: ""))
        convenienceSnapshot(matching: sut)
    }
}
