//
//  GitListViewController.swift
//  GitList
//
//  Created by Elen Souza on 10/06/24.
//

import UIKit

protocol GitListViewControllerProtocol: AnyObject {
    func reloadData()
    func showLoading()
    func dismissLoading()
    func showError(message: String)
}

final class GitListViewController: UIViewController {
    private enum Constants {
        static let activityIndicator: String = "activityIndicator"
        static let collectionView: String = "tableView"
        static let viewEmptyList: String = "viewEmptyList"
        static let cellIdentifier: String = "Cell"
        static let footerIdentifier: String = "Footer"
        static let footerHeight: CGFloat = 80
    }

    private let activity: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView()
        activity.hidesWhenStopped = true
        activity.translatesAutoresizingMaskIntoConstraints = false
        activity.accessibilityIdentifier = Constants.activityIndicator
        return activity
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(GitTableViewCell.self, forCellReuseIdentifier: Constants.cellIdentifier)
        tableView.register(LoadingTableViewReusableView.self, forHeaderFooterViewReuseIdentifier: Constants.footerIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshControl = refreshControl
        tableView.accessibilityIdentifier = Constants.collectionView
        return tableView
    }()

    private let refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: LocalizableStrings.loadingGits)
        return refreshControl
    }()

    private let emptyListView: EmptyListView = {
        let view = EmptyListView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        view.accessibilityIdentifier = Constants.viewEmptyList
        return view
    }()

    private var presenter: GitListPresenterProtocol

    init(presenter: GitListPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        presenter.getGits()
    }
}

private extension GitListViewController {
    func setupViews() {
        configureNavigation()
        setBackgroundDefault()
        addViews()
        addConstraints()
        setupRefreshControl()
    }

    func addViews() {
        view.addSubview(tableView)
        view.addSubview(activity)
        view.addSubview(emptyListView)
    }

    func addConstraints() {
        NSLayoutConstraint.activate([
            activity.topAnchor.constraint(equalTo: view.topAnchor),
            activity.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            activity.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            activity.leadingAnchor.constraint(equalTo: view.leadingAnchor),

            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),

            emptyListView.topAnchor.constraint(equalTo: view.topAnchor),
            emptyListView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emptyListView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            emptyListView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
    }

    func configureNavigation() {
        navigationItem.title = LocalizableStrings.gits
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }

    func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refreshRoundListData(_:)), for: .valueChanged)
    }
}

@objc
private extension GitListViewController {
    func refreshRoundListData(_ sender: Any) {
        presenter.updateGits()
    }
}

extension GitListViewController: GitListViewControllerProtocol {
    func reloadData() {
        emptyListView.isHidden = presenter.gits.isEmpty == false
        tableView.reloadData()
        refreshControl.endRefreshing()
    }

    func showLoading() {
        emptyListView.isHidden = true
        activity.startAnimating()
    }

    func dismissLoading() {
        activity.stopAnimating()
    }

    func showError(message: String) {
        let dialogMessage = UIAlertController(title: LocalizableStrings.oops,
                                              message: message,
                                              preferredStyle: .alert)

        let tryAgainAction = UIAlertAction(title: LocalizableStrings.tryAgain,
                                           style: .default) { [weak self] _ in
            self?.presenter.getGits()
        }

        dialogMessage.addAction(tryAgainAction)

        self.present(dialogMessage, animated: true, completion: nil)
    }

}

extension GitListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let viewModel = presenter.gits[indexPath.row]
        let controller = GitDetailsViewController(viewModel: viewModel)
        navigationController?.pushViewController(controller, animated: true)
    }

    func tableView(_ tableView: UITableView,
                   willDisplayFooterView view: UIView,
                   forSection section: Int) {
        guard tableView.dequeueReusableHeaderFooterView(withIdentifier: Constants.footerIdentifier) != nil,
              presenter.isRequesting == false else {
            return
        }

        presenter.updatePage()
        presenter.getGits()
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        Constants.footerHeight
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}


extension GitListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.gits.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.row < presenter.gits.count,
              let cell: GitTableViewCell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier,
                                                                         for: indexPath) as? GitTableViewCell else {
            return UITableViewCell()
        }
        let item = presenter.gits[indexPath.row]
        cell.setup(with: item)

        return cell
    }

    func tableView(_ tableView: UITableView,
                   viewForFooterInSection section: Int) -> UIView? {
        guard let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: Constants.footerIdentifier) as? LoadingTableViewReusableView else {
            return nil
        }
        return footer
    }
}
