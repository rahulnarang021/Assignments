//
//  ImageDataStorage.swift
//  GelatoImageApp
//
//  Created by RN on 11/07/21.
//

import Foundation

public protocol ImageDataStorage {
    func save(name: String, data: Data, completion:  @escaping ((Error?) -> Void))
}
