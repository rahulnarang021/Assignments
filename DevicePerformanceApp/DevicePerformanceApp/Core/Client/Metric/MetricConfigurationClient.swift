//
//  MetricClient.swift
//  DevicePerformanceApp
//
//  Created by RN on 13/05/21.
//

import Foundation

public protocol MetricConfigurationClient {
    func saveNewThreshold(value: Int, type: MetricType)
    func getThreshold(for type: MetricType) -> Int
    func saveAlertStatus(value: Bool, for metric: MetricType)
    func getAlertStatus(for metric: MetricType) -> Bool
    func getRecoveryAlertStatus(for metric: MetricType) -> Bool
    func saveRecoveryAlertStatus(value: Bool, for metric: MetricType)
}
