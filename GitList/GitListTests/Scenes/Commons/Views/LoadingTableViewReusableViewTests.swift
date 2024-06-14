//
//  LoadingTableViewReusableViewTests.swift
//  GitListTests
//
//  Created by Elen Souza on 13/06/24.
//

import Foundation
import XCTest
import SnapshotTesting

@testable import GitList

final class LoadingTableViewReusableViewTests: XCTestCase {
    var sut: LoadingTableViewReusableView!

    override func setUp() {
        sut = LoadingTableViewReusableView()
        sut.frame = CGRect(x: 0, y: 0, width: 327, height: 100)
        sut.prepareForReuse()
    }

    override func tearDown() {
        sut = nil
    }

    func testSetup() {
        convenienceSnapshot(matching: sut)
    }
}
