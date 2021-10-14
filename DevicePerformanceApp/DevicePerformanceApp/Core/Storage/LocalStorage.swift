//
//  LocalStorage.swift
//  DevicePerformanceApp
//
//  Created by RN on 13/05/21.
//

import Foundation

public protocol LocalStorage {
    func saveValue<T: Encodable>(_ value: T, for key: String)

    func getValue<T: Decodable>(for key: String) -> T?
}
