//
//  GitListAdapterTests.swift
//  GitListTests
//
//  Created by Elen Souza on 13/06/24.
//

import Foundation
import XCTest
@testable import GitList

final class GitListAdapaterTests: XCTestCase {
    func test_adaptToGitCellViewModel() {
        guard let model: [GitResponse] = JSONHelper.getLocalData(fileName: "result",
                                                                 bundle: Bundle(for: type(of: self))) else {
            XCTFail("Failed to load JSON file")
            return
        }

        let result = GitListAdapter.adaptToGitCellViewModel(model)
        let expectedViewModel = buildExpectedViewModel()

        XCTAssertEqual(result, expectedViewModel)
    }

    private func buildExpectedViewModel() -> [GitCellViewModel] {
        [GitCellViewModel(name: "LettyVieira",
                          photoURL: "https://avatars.githubusercontent.com/u/125707542?v=4",
                          fileQuantity: String(format: LocalizableStrings.files, "6")),
         GitCellViewModel(name: "HugsLibRecordKeeper",
                          photoURL: "https://avatars.githubusercontent.com/u/23506375?v=4",
                          fileQuantity: String(format:LocalizableStrings.files, "1")),
         GitCellViewModel(name: "GrahamcOfBorg",
                          photoURL: "https://avatars.githubusercontent.com/u/25447658?v=4",
                          fileQuantity: String(format:LocalizableStrings.files, "1")),
         GitCellViewModel(name: "GrahamcOfBorg",
                          photoURL: "https://avatars.githubusercontent.com/u/25447658?v=4", fileQuantity: String(format:LocalizableStrings.files, "1"))
        ]
    }
}
