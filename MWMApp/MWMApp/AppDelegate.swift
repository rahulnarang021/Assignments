//
//  AppDelegate.swift
//  MWMApp
//
//  Created by RAHUL on 26/06/20.
//  Copyright © 2020 MWM. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var coordinator: TabCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        coordinator = TabbarCoordinator()

        window = UIWindow()
        window?.rootViewController = coordinator?.rootViewController
        window?.makeKeyAndVisible()

        coordinator?.start()
        return true
    }
}

