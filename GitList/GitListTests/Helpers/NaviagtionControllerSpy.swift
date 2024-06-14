//
//  NaviagtionControllerSpy.swift
//  GitListTests
//
//  Created by Elen Souza on 13/06/24.
//

import UIKit
@testable import GitList

final class NavigationControllerSpy: UINavigationController {
    private(set) var pushViewControllerCalled: [(controller: UIViewController, animated: Bool)] = []
    private(set) var presentViewControllerCalled: [(controller: UIViewController, animated: Bool)] = []
    private(set) var dismissViewControllerCalledCount = 0

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
        pushViewControllerCalled.append((viewController, animated))
    }

    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        super.present(viewControllerToPresent, animated: flag, completion: completion)
        presentViewControllerCalled.append((viewControllerToPresent, flag))
    }

    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
        dismissViewControllerCalledCount += 1
    }
}

