//
//  LocalImageItemStore.swift
//  GelatoImageApp
//
//  Created by RN on 05/07/21.
//

import Foundation

class UserdefaultsImageItemStore: Storage {
    func save<T>(data: T, for key: String) throws where T : Encodable {
        let encoder = JSONEncoder()
        let value = try? encoder.encode(data)
        UserDefaults.standard.setValue(value, forKey: key)
    }

    func getData<T>(for key: String) -> T? where T : Decodable {
        let decoder = JSONDecoder()
        if let data = (UserDefaults.standard.value(forKey: key) as? Data) {
            return (try? decoder.decode(T.self, from: data))
        }
        return nil
    }


}
