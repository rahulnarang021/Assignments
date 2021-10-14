//
//  AlertViewComposer.swift
//  DevicePerformanceApp
//
//  Created by RN on 13/05/21.
//

import Foundation
import UIKit

class AlertViewComposer {

    class func composeView(with messages: [AlertModel]) -> UIViewController {
        let viewController = AlertViewController.instantiate()
        viewController.messages = messages
        return viewController
    }
}
