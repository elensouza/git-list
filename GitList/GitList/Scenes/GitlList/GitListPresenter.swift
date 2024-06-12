//
//  GitListPresenter.swift
//  GitList
//
//  Created by Elen Souza on 09/06/24.
//

import Foundation

protocol GitListPresenterProtocol: AnyObject {
    var controller: GitListViewControllerProtocol? { get set }
    var gits: [GitCellViewModel] { get }
    var pages: Int { get }
    var currentPage: Int { get }
    var isRequesting: Bool { get }

    func getGits()
    func updateGits()
    func updatePage()
}

final class GitListPresenter: GitListPresenterProtocol {
    private enum Constants {
        static let page = "page"
    }

    private let service: GitListServiceProtocol

    weak var controller: GitListViewControllerProtocol?
    var pages = 0
    var currentPage = 0
    var gits: [GitCellViewModel] = []
    var isRequesting: Bool = false

    init(service: GitListServiceProtocol = GitListService()) {
        self.service = service
    }

    func getGits() {
        isRequesting = true
        if currentPage == 0 {
            controller?.showLoading()
        }
        service.getGits(params: buildParams()) { [weak self] result in
            self?.isRequesting = false
            self?.controller?.dismissLoading()
            switch result {
            case .success(let response):
                self?.gits.append(contentsOf: GitListAdapter.adaptToGitCellViewModel(response))
                self?.controller?.reloadData()
            case .failure(let error):
                self?.controller?.showError(message: error.localizedDescription)
            }
        }
    }

    func updateGits() {
        resetData()
        getGits()
    }

    func updatePage() {
        currentPage += 1
    }

    private func resetData() {
        pages = 0
        currentPage = 0
        gits = []
    }

    private func buildParams() -> [String: String?] {
        [Constants.page: "\(currentPage)"]
    }
}
