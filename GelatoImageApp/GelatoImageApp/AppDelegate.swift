//
//  AppDelegate.swift
//  GelatoImageApp
//
//  Created by RN on 02/07/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let imageListViewController =  ImageListViewComposer.composeImageListViewController()
        let navController = UINavigationController(rootViewController: imageListViewController)
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = navController
        self.window?.makeKeyAndVisible()
        return true
    }
}

