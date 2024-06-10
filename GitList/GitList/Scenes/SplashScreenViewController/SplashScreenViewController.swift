//
//  SplashScreenViewController.swift
//  GitList
//
//  Created by Elen Souza on 09/06/24.
//

import Foundation
import UIKit

final class SplashScreenViewController: UIViewController {
    private enum Constants {
        static let rotateDelay: CGFloat = 0.2
        static let animationTime: CGFloat = 0.3
        static let animationDelay: CGFloat = 2.0
    }

    private let logoImageView: UIImageView = {
        let imageView = UIImageView(image: Images.githubLogo)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit

        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setBackgroundDefault()
        setupViews()
        view.layoutIfNeeded()
        configAnimation()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.logoImageView.rotate(delay: Constants.rotateDelay)
    }
}

private extension SplashScreenViewController {
    func setupViews() {
        addsSubviews()
        addsConstraints()
    }

    func addsSubviews() {
        view.addSubview(logoImageView)
    }

    func addsConstraints() {
        NSLayoutConstraint.activate([
            logoImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            logoImageView.topAnchor.constraint(equalTo: view.topAnchor),
            logoImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            logoImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func configAnimation() {
        let size = logoImageView.frame.size
        let scale = max(size.width / size.height, size.height / size.width)

        UIView.animate(withDuration: Constants.animationTime, delay: Constants.animationDelay) {
            self.logoImageView.alpha = .zero
            self.logoImageView.transform = self.logoImageView.transform.scaledBy(x: scale, y: scale)
        } completion: { [weak self] _ in
            self?.openListController()
        }
    }

    func openListController() {
        let presenter = GitListPresenter()
        let controller = GitListViewController(presenter: presenter)

        presenter.controller = controller

        self.navigationController?.setViewControllers([controller], animated: false)
    }
}
