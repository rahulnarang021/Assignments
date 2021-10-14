//
//  ImageItemLoader.swift
//  GelatoImageApp
//
//  Created by RN on 04/07/21.
//

import Foundation
public protocol ImageItemLoader {
    typealias Result = Swift.Result<[ImageItem], Swift.Error>
    func load(page: Int, completion: @escaping (Result) -> Void)
}
