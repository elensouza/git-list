//
//  UIViewController+Extensions.swift
//  GitList
//
//  Created by Elen Souza on 09/06/24.
//

import Foundation

import UIKit

extension UIViewController {
    func setBackgroundDefault() {
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        } else {
            view.backgroundColor = .white
        }
    }
}
