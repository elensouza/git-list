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
    func showError()
    func scrollToTop()
}

final class GitListViewController: UIViewController {
    private enum Constants {
        static let activityIndicator: String = "activityIndicator"
        static let collectionView: String = "tableView"
        static let viewEmptyList: String = "viewEmptyList"
        static let barButtonFilter: String = "barButtonFilter"
        static let eightPercent: CGFloat = 0.8
        static let footerHeight: CGFloat = 150
    }

    private let activity: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView()
        activity.hidesWhenStopped = true
        activity.translatesAutoresizingMaskIntoConstraints = false
        activity.accessibilityIdentifier = Constants.activityIndicator
        return activity
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(GitTableViewCell.self, forCellReuseIdentifier: "gitCell" )
        //tableView.register(LoadingTableViewReusableView.self, fo: "footerView")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshControl = refreshControl
        tableView.scrollsToTop = true
        tableView.accessibilityIdentifier = Constants.collectionView
        tableView.tableFooterView = LoadingTableViewReusableView()
        return tableView
    }()

    private let refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string:"Carregando Gits")
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
        navigationItem.title = "Gits"
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
        refreshControl.endRefreshing()
    }
}

extension GitListViewController: GitListViewControllerProtocol {
    func reloadData() {
        emptyListView.isHidden = presenter.gits.isEmpty == false
        tableView.reloadData()
    }

    func showLoading() {
        emptyListView.isHidden = true
        activity.startAnimating()
    }

    func dismissLoading() {
        activity.stopAnimating()
    }

    func showError() {
        let dialogMessage = UIAlertController(title: "",
                                              message: "",
                                              preferredStyle: .alert)

        let tryAgainAction = UIAlertAction(title: "",
                                           style: .default) { [weak self] _ in

            self?.presenter.getGits()
        }

        dialogMessage.addAction(tryAgainAction)

        self.present(dialogMessage, animated: true, completion: nil)
    }

    func scrollToTop() {

    }

}

//extension GitListViewController: UITableViewDelegate {
//    func collectionView(_ collectionView: UICollectionView,
//                        didSelectItemAt indexPath: IndexPath) {
//        collectionView.deselectItem(at: indexPath, animated: true)
//
//        let viewModel = presenter.gits[indexPath.row]
//        let controller = GitDetailsViewController(viewModel: viewModel)
//        self.navigationController?.pushViewController(controller, animated: true)
//    }
//
//    func collectionView(_ collectionView: UICollectionView,
//                        willDisplaySupplementaryView view: UICollectionReusableView,
//                        forElementKind elementKind: String,
//                        at indexPath: IndexPath) {
//        guard elementKind == UICollectionView.elementKindSectionFooter, presenter.isRequesting == false else {
//            return
//        }
//
//        presenter.updatePage()
//        presenter.getGits()
//    }
//}

extension GitListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewModel = presenter.gits[indexPath.row]
        let controller = GitDetailsViewController(viewModel: viewModel)
        self.navigationController?.pushViewController(controller, animated: true)
    }
}


extension GitListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.gits.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: GitTableViewCell = tableView.dequeueReusableCell(withIdentifier: "gitCell", for: indexPath) as? GitTableViewCell else {
            return UITableViewCell()
        }
        let item = presenter.gits[indexPath.row]
        cell.setup(with: item)

        return cell
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        //if presenter.currentPage < presenter.pages {
        return Constants.footerHeight
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height

        if offsetY > contentHeight - height {
            if !presenter.isRequesting {
                presenter.updatePage()
                presenter.getGits()
            }
        }
    }
}
