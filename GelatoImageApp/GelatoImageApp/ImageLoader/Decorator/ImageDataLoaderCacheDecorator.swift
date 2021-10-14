//
//  ImageDataLoaderCacheDecorator.swift
//  GelatoImageApp
//
//  Created by RN on 11/07/21.
//

import Foundation
public class ImageDataLoaderCacheDecorator: ImageDataLoader {

    private let storage: ImageDataStorage
    private let loader: ImageDataLoader

    public init(loader: ImageDataLoader, storage: ImageDataStorage) {
        self.loader = loader
        self.storage = storage
    }

    @discardableResult
    public func load(url: URL, completion: @escaping (ImageDataLoader.Result) -> Void) -> LoaderTask {
        let task = self.loader.load(url: url) {[weak self] result in
            if let data = try? result.get() {
                self?.storage.save(name: url.identifier, data: data) { _ in }
            }
            completion(result)
        }
        return task
    }
}
