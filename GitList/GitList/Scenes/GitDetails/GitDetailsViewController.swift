//
//  GitDetailsViewController.swift
//  GitList
//
//  Created by Elen Souza on 10/06/24.
//

import UIKit

final class GitDetailsViewController: UIViewController {
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        return scrollView
    }()

    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    private var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    private let viewModel: GitCellViewModel

    init(viewModel: GitCellViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
}

private extension GitDetailsViewController {
    func setupViews() {
        configureNavigation()
        setBackgroundDefault()
        addViews()
        addConstraints()
        setupSubviews()
    }

    func addViews() {
        contentView.addSubview(photoImageView)
        contentView.addSubview(nameLabel)
        scrollView.addSubview(contentView)
        view.addSubview(scrollView)
    }

    func addConstraints() {
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            photoImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            photoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Spacing.medium),
            photoImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Spacing.medium),
            photoImageView.heightAnchor.constraint(lessThanOrEqualToConstant: Size.banner),

            nameLabel.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: Spacing.large),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Spacing.medium),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Spacing.medium),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    func setupSubviews() {
        nameLabel.text = String(format: LocalizableStrings.user, viewModel.name)
        photoImageView.download(from: viewModel.photoURL)
    }

    func configureNavigation() {
        navigationItem.title = LocalizableStrings.details
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }
}
