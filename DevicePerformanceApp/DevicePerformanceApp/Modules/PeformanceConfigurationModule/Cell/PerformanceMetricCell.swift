//
//  PerformanceMetricView.swift
//  DevicePerformanceApp
//
//  Created by RN on 13/05/21.
//

import UIKit

class PerformanceMetricCell: UITableViewCell {

    @IBOutlet weak var recoverySwitchView: UISwitch!
    @IBOutlet weak var metricLabel: UILabel!
    @IBOutlet weak var recoveryTitleLabel: UILabel!
    @IBOutlet weak var thresholdValueLabel: UILabel!
    @IBOutlet weak var alertSwitchView: UISwitch!
    @IBOutlet weak var slider: UISlider!
    weak var delegate: PerformanceMetricCellViewDelegate?

    func configureView(_ viewModel: MetricViewModel, delegate: PerformanceMetricCellViewDelegate) {
        self.delegate = delegate
        self.slider.value = viewModel.threshold
        configureThresholdLabel(viewModel.threshold)
        self.metricLabel.text = viewModel.name
        self.alertSwitchView.isOn = viewModel.isAlertEnabled
        self.recoverySwitchView.isOn = viewModel.isRecoveryAlertEnabled
        self.recoveryTitleLabel.text = viewModel.recoveryTitle
    }

    // MARK: - Actions
    @IBAction func didChangeSliderValue(_ sender: UISlider) {
        configureThresholdLabel(sender.value)
        delegate?.didChangeThreshold(newValue: Int(sender.value * 100))
    }

    @IBAction func didChangeAlert(_ sender: UISwitch) {
        delegate?.didChangeAlertStatus(isAlertEnabled: sender.isOn)
    }
    @IBAction func didChangeRecoveryAlert(_ sender: UISwitch) {
        delegate?.didChangeRecoveryAlertStatus(isAlertEnabled: sender.isOn)
    }
    
    func configureThresholdLabel(_ value: Float) {
        thresholdValueLabel.text = "\(Int(value * 100))%"
    }
}
