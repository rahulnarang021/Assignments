//
//  LocalMetricClient.swift
//  DevicePerformanceApp
//
//  Created by RN on 13/05/21.
//

import Foundation
public class LocalMetricConfigurationClient: MetricConfigurationClient {
    let storage: LocalStorage

    public init(storage: LocalStorage) {
        self.storage = storage
    }

    public func saveNewThreshold(value: Int, type: MetricType) {
        storage.saveValue(value, for: KeyParser.thresholdKey(type: type))
    }

    public func getThreshold(for type: MetricType) -> Int {
        if let value: Int = storage.getValue(for: KeyParser.thresholdKey(type: type)) {
            return value
        }
        return 0
    }

    public func saveAlertStatus(value: Bool, for type: MetricType) {
        storage.saveValue(value, for: KeyParser.alertKey(type: type))
    }

    public func getAlertStatus(for type: MetricType) -> Bool {
        if let isAlertOn: Bool = storage.getValue(for: KeyParser.alertKey(type: type)) {
            return isAlertOn
        }
        return false

    }

    public func saveRecoveryAlertStatus(value: Bool, for type: MetricType) {
        storage.saveValue(value, for: KeyParser.recoveryAlertKey(type: type))
    }

    public func getRecoveryAlertStatus(for type: MetricType) -> Bool {
        if let isAlertOn: Bool = storage.getValue(for: KeyParser.recoveryAlertKey(type: type)) {
            return isAlertOn
        }
        return false

    }
}
