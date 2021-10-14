//
//  MessageStorage.swift
//  DevicePerformanceApp
//
//  Created by RN on 13/05/21.
//

import Foundation

public protocol AlertStorage {
    func addAlert(_ message: AlertModel)
    func getAllAlerts() -> [AlertModel]
}
