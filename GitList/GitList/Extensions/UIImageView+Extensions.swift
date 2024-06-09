//
//  UIImageView+Extensions.swift
//  GitList
//
//  Created by Elen Souza on 09/06/24.
//

import Foundation
import UIKit

extension UIImageView {
    func download(from url: String) {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.startAnimating()
        activityIndicator.center = center

        addSubview(activityIndicator)

        guard let urlPhoto = URL(string: url) else {
            activityIndicator.removeFromSuperview()
            self.image = Images.noImageAvailable
            return
        }

        DispatchQueue.global().async {
            guard let data = try? Data(contentsOf: urlPhoto) else {
                DispatchQueue.main.async { [weak self] in
                    activityIndicator.removeFromSuperview()
                    self?.image = Images.noImageAvailable
                }
                return
            }
            DispatchQueue.main.async { [weak self] in
                activityIndicator.removeFromSuperview()
                self?.image = UIImage(data: data)
            }
        }
    }
}

