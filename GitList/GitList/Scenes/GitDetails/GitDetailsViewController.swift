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
            photoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            photoImageView.heightAnchor.constraint(lessThanOrEqualToConstant: Size.banner),

            nameLabel.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: Spacing.large),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Spacing.small),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Spacing.small),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    func setupSubviews() {
        nameLabel.text = viewModel.name
        photoImageView.download(from: viewModel.photoURL)
    }

    func configureNavigation() {
        navigationItem.title = viewModel.name
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }
}

private extension GitDetailsViewController {
    func buildRow(with title: String, value: String) -> UIStackView {
        let titleLabel = buildTitle(title)
        let valueLabel = buildValue(value)
        let stackView = UIStackView(arrangedSubviews: [titleLabel, valueLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = Spacing.small

        NSLayoutConstraint.activate([
            titleLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.3),
            stackView.heightAnchor.constraint(equalToConstant: Size.defaultHeight)
        ])

        return stackView
    }

    func buildTitle(_ title: String) -> UILabel {
        let color = Colors.primary
        let label = buildLabel(title, color: color)
        label.font = .boldSystemFont(ofSize: UIFont.labelFontSize)
        label.backgroundColor = color.withAlphaComponent(Alpha.small)
        return label
    }

    func buildValue(_ value: String) -> UILabel {
        let color = Colors.primary
        let label = buildLabel(value, color: color)
        label.font = .systemFont(ofSize: UIFont.labelFontSize)
        label.backgroundColor = color.withAlphaComponent(Alpha.xSmall)
        return label
    }

    func buildLabel(_ text: String, color: UIColor) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = color
        label.textAlignment = .center
        label.layer.masksToBounds = true
        label.layer.cornerRadius = Radius.small
        label.text = text
        return label
    }
}
