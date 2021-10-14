//
//  ImageItemStorage.swift
//  GelatoImageApp
//
//  Created by RN on 05/07/21.
//

import Foundation

public protocol ImageItemStorage {
    func save(page: Int, imageItems: [ImageItem])
}
