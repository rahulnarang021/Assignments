//
//  MetricCellView.swift
//  DevicePerformanceApp
//
//  Created by RN on 14/05/21.
//

import UIKit

public protocol MetricCellView {
    func getCell(for tablView: UITableView) -> UITableViewCell
}

protocol PerformanceMetricCellViewDelegate: class {
    func didChangeThreshold(newValue: Int)
    func didChangeAlertStatus(isAlertEnabled: Bool)
    func didChangeRecoveryAlertStatus(isAlertEnabled: Bool)
}

