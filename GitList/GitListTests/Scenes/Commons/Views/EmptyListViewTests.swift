//
//  EmptyListViewTests.swift
//  GitListTests
//
//  Created by Elen Souza on 13/06/24.
//

import Foundation
import XCTest
import SnapshotTesting

@testable import GitList

final class EmptyListViewTests: XCTestCase {
    var sut: EmptyListView!

    override func setUp() {
        sut = EmptyListView()
        sut.frame = CGRect(x: 0, y: 0, width: 327, height: 500)
    }

    override func tearDown() {
        sut = nil
    }

    func testSetup() {
        convenienceSnapshot(matching: sut)
    }
}
