//
//  MetricType.swift
//  DevicePerformanceApp
//
//  Created by RN on 13/05/21.
//

import Foundation

public enum MetricType: Int, CaseIterable {
    case battery = 1
    case memory = 2
    case cpu = 3
}

public extension MetricType {
    func getTitle() -> String {
        switch self {
        case .battery:
            return "Battery"
        case .memory:
            return "Memory"
        case .cpu:
            return "CPU"
        }
    }

    func getKey() -> String {
        switch self {
        case .battery:
            return "Battery"
        case .memory:
            return "Memory"
        case .cpu:
            return "CPU"
        }
    }

}

