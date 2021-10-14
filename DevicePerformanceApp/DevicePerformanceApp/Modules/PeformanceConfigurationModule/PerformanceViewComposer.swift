//
//  PerformanceViewComposer.swift
//  DevicePerformanceApp
//
//  Created by RN on 13/05/21.
//

import Foundation
import UIKit

class PerformanceViewComposer {
    class func composeView(client: MetricConfigurationClient, alertClicked: @escaping () -> Void) -> UIViewController {
        let presenter = PerformanceViewPresenter(client: client, alertClicked: alertClicked)
        return PerformanceViewController
            .instantiateView(withPresenter: presenter)
    }
}
