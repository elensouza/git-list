//
//  LoadingTableViewReusableView.swift
//  GitList
//
//  Created by Elen Souza on 10/06/24.
//

import UIKit

final class LoadingTableViewReusableView: UITableViewHeaderFooterView {
    private let activity: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView()
        activity.translatesAutoresizingMaskIntoConstraints = false
        return activity
    }()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        addViews()
        addsConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func prepareForReuse() {
        activity.startAnimating()
    }

    private func addViews() {
        addSubview(activity)
    }

    private func addsConstraints() {
        NSLayoutConstraint.activate([
            activity.centerXAnchor.constraint(equalTo: centerXAnchor),
            activity.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
