//
//  MessageStorageService.swift
//  DevicePerformanceApp
//
//  Created by RN on 13/05/21.
//

import Foundation

class AlertStorageService: AlertStorage {

    var storage: LocalStorage
    init(storage: LocalStorage) {
        self.storage = storage
    }

    func addAlert(_ message: AlertModel) {
        var allMessages = getAllAlerts()
        allMessages.append(message)
        storage.saveValue(allMessages, for: "alertMessages")
    }

    func getAllAlerts() -> [AlertModel] {
        return (storage.getValue(for: "alertMessages") ?? [])
    }


}
