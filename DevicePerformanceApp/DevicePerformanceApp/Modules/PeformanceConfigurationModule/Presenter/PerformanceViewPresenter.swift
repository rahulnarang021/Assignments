//
//  PerformanceViewPresenter.swift
//  DevicePerformanceApp
//
//  Created by RN on 13/05/21.
//

import Foundation


public protocol PerformancePresenter {
    var controllers: [MetricCellView] { get }
    var title: String { get }
    func didClickAlert()
}

public class PerformanceViewPresenter: PerformancePresenter {
    private let client: MetricConfigurationClient

    public var controllers: [MetricCellView] = []
    private var alertClicked: (() -> Void)

    public var title: String {
        return "Metric Configuration"
    }
    
    public init(client: MetricConfigurationClient, alertClicked: @escaping (() -> Void)) {
        self.client = client
        self.alertClicked = alertClicked
        configureControllers()
    }

    public func configureControllers() {
        controllers = []
        for metricType in MetricType.allCases {
            let viewModel = getMetricViewModel(for: metricType)

            let controller = PerformanceMetricCellController(type: metricType, viewModel: viewModel, delegate: self)
            controllers.append(controller)
        }
    }

    private func getMetricViewModel(for type: MetricType) -> MetricViewModel {
        return MetricViewModel(name: type.getTitle(),
                               threshold: (Float(client.getThreshold(for: type)) / 100),
                               isAlertEnabled: client.getAlertStatus(for: type), isRecoveryAlertEnabled: client.getRecoveryAlertStatus(for: type))
    }

    public func didClickAlert() {
        alertClicked()
    }

}

extension PerformanceViewPresenter: MetricControllerDelegate {
    public func didChangeThreshold(to value: Int, type: MetricType) {
        client.saveNewThreshold(value: value, type: type)
    }

    public func didEnableDisableAlert(isAlertOn: Bool, type: MetricType) {
        client.saveAlertStatus(value: isAlertOn, for: type)
    }

    public func didChangeRecoveryAlertStatus(isAlertEnabled: Bool, type: MetricType) {
        client.saveRecoveryAlertStatus(value: isAlertEnabled, for: type)
    }
}
