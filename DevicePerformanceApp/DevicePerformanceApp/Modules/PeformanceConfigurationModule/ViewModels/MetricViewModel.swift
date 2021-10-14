//
//  MetricViewModel.swift
//  DevicePerformanceApp
//
//  Created by RN on 13/05/21.
//

import Foundation
struct MetricViewModel {
    let name: String
    let threshold: Float
    let isAlertEnabled: Bool
    let isRecoveryAlertEnabled: Bool
    var recoveryTitle: String {
        "Show Recovery Alert"
    }
}
