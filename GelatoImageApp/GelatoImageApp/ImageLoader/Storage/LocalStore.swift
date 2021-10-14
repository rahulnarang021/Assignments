//
//  LocalStore.swift
//  GelatoImageApp
//
//  Created by RN on 11/07/21.
//

import Foundation
public protocol LocalStore {
    func load(name: String, completion: @escaping (Result<Data, Error>) -> Void)
}
