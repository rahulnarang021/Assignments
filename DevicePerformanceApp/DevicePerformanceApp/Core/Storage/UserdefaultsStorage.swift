//
//  UserdefaultsStorage.swift
//  DevicePerformanceApp
//
//  Created by RN on 13/05/21.
//

import Foundation
class UserdefaultLocalStorage: LocalStorage {
    
    func saveValue<T>(_ value: T, for key: String) where T : Encodable {
        let encoder = JSONEncoder()
        let data = try? encoder.encode(value)
        UserDefaults.standard.setValue(data, forKey: key)
    }

    func getValue<T>(for key: String) -> T? where T : Decodable {
        let decoder = JSONDecoder()
        if let data = (UserDefaults.standard.value(forKey: key) as? Data) {
            return (try? decoder.decode(T.self, from: data))
        }
        return nil
    }


}
