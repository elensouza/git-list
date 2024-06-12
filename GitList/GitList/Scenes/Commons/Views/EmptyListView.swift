//
//  EmptyListView.swift
//  GitList
//
//  Created by Elen Souza on 10/06/24.
//

import UIKit

final class EmptyListView: UIView {
    private let emptyImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.image = Images.emptyListIcon
        view.tintColor = Colors.primary
        return view
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.text = LocalizableStrings.noResults
        return label
    }()

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        addViews()
        addsConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addViews() {
        addSubview(emptyImageView)
        addSubview(descriptionLabel)
    }

    private func addsConstraints() {
        NSLayoutConstraint.activate([
            emptyImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            emptyImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            emptyImageView.heightAnchor.constraint(equalToConstant: Size.largeIcon),
            emptyImageView.widthAnchor.constraint(equalToConstant: Size.largeIcon),

            descriptionLabel.topAnchor.constraint(equalTo: emptyImageView.bottomAnchor,
                                                  constant: Spacing.medium),
            descriptionLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            descriptionLabel.leadingAnchor.constraint(greaterThanOrEqualTo: self.leadingAnchor,
                                                      constant: Spacing.large),
            descriptionLabel.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor,
                                                       constant: -Spacing.large),
            descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor)
        ])
    }
}
