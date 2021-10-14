//
//  MetricAlertServiceTests.swift
//  DevicePerformanceAppTests
//
//  Created by RN on 13/05/21.
//

import XCTest
import DevicePerformanceApp

class MetricAlertServiceTests: XCTestCase {

    func test_shouldShouldFireShowAlert_OnInit() {
        var messageCount = 0
        let _ = makeSUT { (_, _, _) in
            messageCount += 1
        }
        XCTAssertTrue(messageCount == 0, "Expected No Alert Call trigerred on init but got \(messageCount) instead")
    }

    func test_calculateAlertCondition_shouldNotFireAlertAllMetricsAreBelowThreshold() {
        var messageCount = 0
        let sut = makeSUT { (_, _, _) in
            messageCount += 1
        }
        sut.client.threshold[.cpu] = 50
        sut.calculator.cpuLoadPercentage = 40
        sut.alertService.calculateAlertCondition()
        XCTAssertTrue(messageCount == 0, "Expected No Alert Call trigerred when all thresholds are above actual values")
    }

    func test_calculateAlertCondition_shouldFireAlertWhenAnyMetricIsAboveThreshold() {
        var messageCount = 0
        let sut = makeSUT { (_, _, _) in
            messageCount += 1
        }
        sut.client.threshold[.cpu] = 50
        sut.client.alertStatus[.cpu] = true
        sut.calculator.cpuLoadPercentage = 60
        sut.alertService.calculateAlertCondition()
        XCTAssertTrue(messageCount == 1, "Expected one Alert Call trigerred when any value is above threshold but got \(messageCount) instead")
    }

    func test_calculateAlertCondition_shouldNotFireAlertWhenAnyMetricIsAboveThresholdOnAlertOff() {
        var messageCount = 0
        let sut = makeSUT { (_, _, _) in
            messageCount += 1
        }
        sut.client.threshold[.cpu] = 50
        sut.client.alertStatus[.cpu] = false
        sut.calculator.cpuLoadPercentage = 60
        sut.alertService.calculateAlertCondition()
        XCTAssertTrue(messageCount == 0, "Expected one Alert Call trigerred when any value is above threshold but got \(messageCount) instead")
    }

    func test_calculateAlertCondition_shouldFireMultipleAlertWhenMetricsAreAboveThreshold() {
        var messageCount = 0
        let sut = makeSUT { (_, _, _) in
            messageCount += 1
        }
        sut.client.threshold[.cpu] = 50
        sut.client.alertStatus[.cpu] = true

        sut.client.threshold[.memory] = 50
        sut.client.alertStatus[.memory] = true

        sut.calculator.cpuLoadPercentage = 60
        sut.calculator.usedMemoryPercentage = 60

        sut.alertService.calculateAlertCondition()
        XCTAssertTrue(messageCount == 2, "Expected two Alerts Call trigerred when any value is above threshold but got \(messageCount) instead")
    }

    func test_calculateAlertCondition_shouldFireSingleAlertWhenMetricsAreAboveThresholdOnOffAlert() {
        var messageCount = 0
        let sut = makeSUT { (_, _, _) in
            messageCount += 1
        }
        sut.client.threshold[.cpu] = 50
        sut.client.alertStatus[.cpu] = true

        sut.client.threshold[.memory] = 50
        sut.client.alertStatus[.memory] = false

        sut.calculator.cpuLoadPercentage = 60
        sut.calculator.usedMemoryPercentage = 60

        sut.alertService.calculateAlertCondition()
        XCTAssertTrue(messageCount == 1, "Expected one Alert Call trigerred when any value is above threshold but got \(messageCount) instead")
    }

    func test_calculateAlertCondition_shouldFireRecoveryAlertWhenErrorIsRecovered() {
        var capturedAlert: AlertType?
        let sut = makeSUT { (message, alertType, metricType) in
            capturedAlert = alertType
        }
        sut.client.threshold[.cpu] = 50
        sut.client.alertStatus[.cpu] = true
        sut.calculator.cpuLoadPercentage = 60

        sut.alertService.calculateAlertCondition()
        XCTAssertEqual(capturedAlert, .error , "Expected Error Alert Call trigerred when any value is above threshold but got \(String(describing: capturedAlert)) instead")

        sut.calculator.cpuLoadPercentage = 40
        sut.client.recoveryAlertStatus[.cpu] = true
        sut.alertService.calculateAlertCondition()

        XCTAssertEqual(capturedAlert, .success , "Expected Success Alert Call trigerred when any value is above threshold but got \(String(describing: capturedAlert)) instead")
    }

    func test_calculateAlertCondition_shouldNotFireRecoveryAlertWhenErrorIsRecoveredAndRecoveryAlertIsOff() {
        var capturedAlert: AlertType?
        let sut = makeSUT { (message, alertType, metricType) in
            capturedAlert = alertType
        }
        sut.client.threshold[.cpu] = 50
        sut.client.alertStatus[.cpu] = true
        sut.calculator.cpuLoadPercentage = 60

        sut.alertService.calculateAlertCondition()
        XCTAssertEqual(capturedAlert, .error , "Expected Error Alert Call trigerred when any value is above threshold but got \(String(describing: capturedAlert)) instead")

        capturedAlert = nil
        sut.calculator.cpuLoadPercentage = 40
        sut.client.recoveryAlertStatus[.cpu] = false
        sut.alertService.calculateAlertCondition()

        XCTAssertNil(capturedAlert , "Expected No Alert Call trigerred when any recovery alert is off but got \(String(describing: capturedAlert)) instead")
    }

    func test_calculateAlertCondition_ShouldSaveMessagesOnErrorAlertIfAlertIsOn() {
        let sut = makeSUT { (message, alertType, metricType) in
        }
        sut.client.threshold[.cpu] = 50
        sut.client.alertStatus[.cpu] = true
        sut.calculator.cpuLoadPercentage = 60

        sut.alertService.calculateAlertCondition()
        XCTAssertEqual(sut.messageStorage.messages.count, 1, "Expected 1 message in alert storage but got \(sut.messageStorage.messages.count) instead")

    }

    private func makeSUT(action: @escaping MetricAlertService.AlertAction) -> (messageStorage: AlertStorageStub ,alertService: MetricAlertService, client: MetricClientStub, calculator: MetricCalculatorStub) {
        let client = MetricClientStub()
        let calculator = MetricCalculatorStub()
        let storage = AlertStorageStub()
        let alertService = MetricAlertService(storage: storage,
                                              client: client,
                                              calculator: calculator,
                                              showAlert: action)
        return (messageStorage: storage, alertService: alertService, client: client, calculator: calculator)
    }

    private class AlertStorageStub: AlertStorage {
        var messages: [AlertModel] = []
        func addAlert(_ message: AlertModel) {
            messages.append(message)
        }

        func getAllAlerts() -> [AlertModel] {
            return messages
        }
    }

    private class MetricCalculatorStub: MetricCalculatorClient {
        var cpuLoadPercentage: Int = 0
        var usedMemoryPercentage: Int = 0
        var usedBatteryPercentage: Int = 0

        func getUsedCPULoadPercentage() -> Int {
            return cpuLoadPercentage
        }

        func getUsedMemoryPercentage() -> Int {
            return usedMemoryPercentage
        }

        func getUsedBatteryPercentage() -> Int {
            return usedBatteryPercentage
        }
    }
}
