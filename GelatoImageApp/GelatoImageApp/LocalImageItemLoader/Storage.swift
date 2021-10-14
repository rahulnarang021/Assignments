//
//  Storage.swift
//  GelatoImageApp
//
//  Created by RN on 05/07/21.
//

import Foundation

public protocol Storage {
    func save<T: Encodable>(data: T, for key: String) throws
    func getData<T: Decodable> (for key: String) -> T?
}

