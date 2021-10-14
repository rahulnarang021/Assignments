//
//  MetricAlertService.swift
//  DevicePerformanceAppTests
//
//  Created by RN on 13/05/21.
//

import UIKit

public enum AlertType {
    case success
    case error
}

public class MetricAlertService {
    public typealias AlertAction = (String, AlertType, MetricType) -> Void

    private let client: MetricConfigurationClient
    private let storage: AlertStorage
    private let calculator: MetricCalculatorClient
    private let showUIAlert: MetricAlertService.AlertAction

    private var currentAlerts: Set<MetricType> = Set<MetricType>()
    public init(storage: AlertStorage, client: MetricConfigurationClient, calculator: MetricCalculatorClient, showAlert: @escaping AlertAction) {
        self.client = client
        self.storage = storage
        self.calculator = calculator
        self.showUIAlert = showAlert
    }

    public func calculateAlertCondition() {
        for type in MetricType.allCases {
            showNotification(for: type)
        }
    }

    private func showNotification(for metricType: MetricType) {
        let isAlertNotificationOn = client.getAlertStatus(for: metricType)
        let isRecoveryAlertNotificationOn = client.getRecoveryAlertStatus(for: metricType)
        let threshold = client.getThreshold(for: metricType)

        configureAlert(for: threshold,
                       metricType: metricType,
                       configuration: (alertStatus: isAlertNotificationOn, recoveryStatus: isRecoveryAlertNotificationOn))
    }
    
    // MARK: - Helpers to show Alert
    private func configureAlert(for threshold: Int,
                        metricType: MetricType,
                        configuration:(alertStatus: Bool, recoveryStatus: Bool)) {
        let consumedValue = getUsedPercentage(metricType)
        if configuration.alertStatus == true, consumedValue > threshold {
            self.fireAlert("\(metricType.getTitle()) consumption is \(consumedValue)% which is higher than \(threshold)%", metricType: metricType, alertType: .error)
        } else if configuration.recoveryStatus == true && currentAlerts.contains(metricType) {

            currentAlerts.remove(metricType)
            self.fireAlert("\(metricType.getTitle()) consumption is \(consumedValue)% which is lower than \(threshold)%", metricType: metricType, alertType: .success)
        }
    }


    private func getUsedPercentage(_ metricType: MetricType) -> Int {
        switch metricType {
        case .battery:
            return calculator.getUsedBatteryPercentage()
        case .cpu:
            return calculator.getUsedCPULoadPercentage()
        case .memory:
            return calculator.getUsedMemoryPercentage()
        }
    }


    private func fireAlert(_ message: String, metricType: MetricType, alertType: AlertType) {
        saveAlertIfNeeded(message, alertType, metricType)
        showUIAlert(message, alertType, metricType)
    }

    private func saveAlertIfNeeded(_ message: String, _ alertType: AlertType, _ metricType: MetricType) {
        if alertType == .error {
            storage.addAlert(AlertModel(alert: message))
            currentAlerts.insert(metricType)
        }

    }
}
