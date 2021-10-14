//
//  UIWindow+TopViewController.swift
//  GelatoImageApp
//
//  Created by RN on 05/07/21.
//

import UIKit

extension UIWindow {

    func topViewController() -> UIViewController? {
        guard var topVC = self.rootViewController else {
            return nil
        }
        while let presentedVC = topVC.presentedViewController {
            topVC = presentedVC;
        }

        if let tabbarVC = topVC as? UITabBarController, let selectedVC =  tabbarVC.selectedViewController {
            topVC = selectedVC
        }

        if let navigationVC = topVC as? UINavigationController, let selectedVC =  navigationVC.topViewController {
            topVC = selectedVC
        }
        return topVC
    }
}
