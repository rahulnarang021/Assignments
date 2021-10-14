//
//  MetricController.swift
//  DevicePerformanceApp
//
//  Created by RN on 13/05/21.
//

import Foundation
import UIKit

public protocol MetricControllerDelegate: class {
    func didChangeThreshold(to value: Int, type: MetricType)
    func didEnableDisableAlert(isAlertOn: Bool, type: MetricType)
    func didChangeRecoveryAlertStatus(isAlertEnabled: Bool, type: MetricType)
}

class PerformanceMetricCellController: MetricCellView {

    weak var delegate: MetricControllerDelegate?
    let viewModel: MetricViewModel
    let type: MetricType

    init(type: MetricType, viewModel: MetricViewModel, delegate: MetricControllerDelegate) {
        self.type = type
        self.delegate = delegate
        self.viewModel = viewModel
    }

    func getCell(for tablView: UITableView) -> UITableViewCell {
        let cell = tablView.dequeueReusableCell(withIdentifier: PerformanceMetricCell.reusableIdentifier) as! PerformanceMetricCell // force casting as it should be registered else setup error and user should know about that while running the app
        cell.configureView(viewModel, delegate: self)
        return cell
    }
}

extension PerformanceMetricCellController: PerformanceMetricCellViewDelegate {
    func didChangeThreshold(newValue: Int) {
        delegate?.didChangeThreshold(to: newValue, type: type)
    }

    func didChangeAlertStatus(isAlertEnabled: Bool) {
        delegate?.didEnableDisableAlert(isAlertOn: isAlertEnabled, type: type)
    }

    func didChangeRecoveryAlertStatus(isAlertEnabled: Bool) {
        delegate?.didChangeRecoveryAlertStatus(isAlertEnabled: isAlertEnabled, type: type)
    }
}
