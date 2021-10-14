//
//  MessageModel.swift
//  DevicePerformanceApp
//
//  Created by RN on 13/05/21.
//

import Foundation

public struct AlertModel: Codable {
    let alert: String
    let date: Date
    public init(alert: String) {
        self.alert = alert
        self.date = Date()
    }
}
