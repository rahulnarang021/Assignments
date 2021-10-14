//
//  MetricClientStub.swift
//  DevicePerformanceAppTests
//
//  Created by RN on 13/05/21.
//

import XCTest
import DevicePerformanceApp

class MetricClientStub: MetricConfigurationClient {

    var alertStatus: [MetricType: Bool] = [:]
    var recoveryAlertStatus: [MetricType: Bool] = [:]
    var threshold: [MetricType: Int] = [:]

    var savedThreshold:[MetricType: Int] = [:]
    var savedAlertStatus:[MetricType: Bool] = [:]
    var savedRecoveryAlertStatus:[MetricType: Bool] = [:]

    func saveNewThreshold(value: Int, type: MetricType) {
        savedThreshold[type] = value
    }

    func getThreshold(for type: MetricType) -> Int {
        return (threshold[type] ?? 0)
    }

    func saveAlertStatus(value: Bool, for metric: MetricType) {
        savedAlertStatus[metric] = value
    }

    func getAlertStatus(for metric: MetricType) -> Bool {
        return (alertStatus[metric] ?? false)
    }

    func getRecoveryAlertStatus(for metric: MetricType) -> Bool {
        return (recoveryAlertStatus[metric] ?? false)
    }

    func saveRecoveryAlertStatus(value: Bool, for metric: MetricType) {
        savedRecoveryAlertStatus[metric] = value
    }

}
