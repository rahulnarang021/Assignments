//
//  AppComposer.swift
//  DevicePerformanceApp
//
//  Created by RN on 14/05/21.
//

import UIKit

class ApplicationComposer {

    private let alertPeriodicTimer = 5.0

    private let storage: LocalStorage
    private let client: MetricConfigurationClient
    private let notificationClient: TimerClient
    private let alertStorage: AlertStorage

    lazy var navigationController = UINavigationController()

    init(toastAction: @escaping MetricAlertService.AlertAction) {
        self.storage = UserdefaultLocalStorage()
        self.client = LocalMetricConfigurationClient(storage: storage)
        self.alertStorage = AlertStorageService(storage: storage)
        let metricAlertClient = MetricAlertService(storage: alertStorage, client: client,
                                                   calculator: MetricCalculatorService()) {(message, alertType, metricType) in
            toastAction(message, alertType, metricType)
        }

        notificationClient = TimerService(periodicInterval: alertPeriodicTimer, action: metricAlertClient.calculateAlertCondition)
    }

    func applicationDidBecomeActive() {
        notificationClient.start()
    }

    func applicationDidResignActive() {
        notificationClient.stop()
    }

    func openPerformanceVC() {
        let performanceVC = getPerformanceVC {[weak self] in
            self?.openAlertVC()
        }
        navigationController.viewControllers = [performanceVC]
    }

    private func openAlertVC() {
        let messages = alertStorage.getAllAlerts()
        let alertVC = AlertViewComposer.composeView(with: messages)
        navigationController.pushViewController(alertVC, animated: true)
    }

    private func getPerformanceVC(alertClicked: @escaping () -> Void) -> UIViewController {
        let viewController = PerformanceViewComposer.composeView(client: client, alertClicked: alertClicked)
        return viewController
    }

}
