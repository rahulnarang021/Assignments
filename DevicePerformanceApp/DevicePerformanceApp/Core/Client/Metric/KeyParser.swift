//
//  KeyParser.swift
//  DevicePerformanceApp
//
//  Created by RN on 13/05/21.
//

import Foundation
public struct KeyParser {
    public static func thresholdKey(type: MetricType) -> String {
        let key = type.getKey()
        return "threshold_\(key)"
    }

    public static func alertKey(type: MetricType) -> String {
        let key = type.getKey()
        return "alert_\(key)"
    }

    public static func recoveryAlertKey(type: MetricType) -> String {
        let key = type.getKey()
        return "recovery_alert_\(key)"
    }

}

