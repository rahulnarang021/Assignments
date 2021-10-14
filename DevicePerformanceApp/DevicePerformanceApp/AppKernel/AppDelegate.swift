//
//  AppDelegate.swift
//  DevicePerformanceApp
//
//  Created by RN on 12/05/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var composer: ApplicationComposer?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        composer = ApplicationComposer(toastAction: self.showAlert)
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = composer?.navigationController
        self.window?.makeKeyAndVisible()

        composer?.openPerformanceVC()
        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        composer?.applicationDidBecomeActive()
    }

    func applicationWillResignActive(_ application: UIApplication) {
        composer?.applicationDidResignActive()
    }

    // MARK: - ShowUIAlert
    func showAlert(message: String, alertType: AlertType, metricType: MetricType) {
        let color = alertType == .error ? UIColor.red : UIColor.green
        UIApplication.shared.keyWindow?.topViewController()?.showToast(message: message, color: color, bottomPadding: getPadding(from: metricType))
    }

    private func getPadding(from metricType: MetricType) -> CGFloat { // Hack which can be removed with more UI configuration
        switch metricType {
        case .battery:
            return 200
        case .memory:
            return 150
        case .cpu:
            return 100
        }
    }
}

