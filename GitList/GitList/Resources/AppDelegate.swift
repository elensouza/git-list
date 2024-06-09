//
//  AppDelegate.swift
//  GitList
//
//  Created by Elen Souza on 09/06/24.
//

import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupAppearance()

        self.window = UIWindow()

        let controller = SplashScreenViewController()
        let navigationController = UINavigationController(rootViewController: controller)

        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

        return true
    }
}

private extension AppDelegate {
    func setupAppearance() {
        let color = Colors.primary
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: color]
        UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: color]
        UIBarButtonItem.appearance().tintColor = color
    }
}


