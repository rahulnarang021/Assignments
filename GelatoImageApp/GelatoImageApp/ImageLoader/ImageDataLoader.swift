//
//  ImageDataLoader.swift
//  GelatoImageApp
//
//  Created by RN on 09/07/21.
//

import Foundation
public protocol ImageDataLoader {
    typealias Result = Swift.Result<Data, Error>

    @discardableResult
    func load(url: URL, completion: @escaping (ImageDataLoader.Result) -> Void) -> LoaderTask
}
