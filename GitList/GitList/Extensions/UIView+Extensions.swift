//
//  UIView+Extensions.swift
//  GitList
//
//  Created by Elen Souza on 09/06/24.
//

import UIKit

extension UIView {
    func rotate(delay: CGFloat) {
        /// https://developer.apple.com/documentation/quartzcore/cabasicanimation
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")

        animation.beginTime = CACurrentMediaTime() + delay
        animation.fromValue = 0.0
        animation.toValue = .pi * 0.5
        animation.duration = 1.0
        animation.isCumulative = true
        animation.repeatCount = .infinity

        layer.add(animation, forKey: "rotationAnimation")
    }
}
