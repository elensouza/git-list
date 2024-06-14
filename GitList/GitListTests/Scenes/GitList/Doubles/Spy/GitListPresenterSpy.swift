//
//  GitListPresenterSpy.swift
//  GitListTests
//
//  Created by Elen Souza on 13/06/24.
//

import Foundation
@testable import GitList

final class GitListPresenterSpy : GitListPresenterProtocol {
    var controller: GitListViewControllerProtocol?

    var gits: [GitCellViewModel] = []
    var currentPage: Int = 0
    var isRequesting: Bool = false

    private(set) var getGitsCalledCount = 0
    private(set) var updateGitsCalledCount = 0

    func getGits() {
        getGitsCalledCount += 1
    }

    func updateGits() {
        updateGitsCalledCount += 1
    }

    func updatePage() {
        currentPage += 1
    }
}
