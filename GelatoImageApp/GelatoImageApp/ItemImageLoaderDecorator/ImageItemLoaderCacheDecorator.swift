//
//  ImageItemLoaderCacheDecorator.swift
//  GelatoImageApp
//
//  Created by RN on 06/07/21.
//

import Foundation
public class ImageItemLoaderCacheDecorator: ImageItemLoader {

    private let storage: ImageItemStorage
    private let loader: ImageItemLoader

    public init(loader: ImageItemLoader, storage: ImageItemStorage) {
        self.loader = loader
        self.storage = storage
    }

    public func load(page: Int, completion: @escaping (ImageItemLoader.Result) -> Void) {
        loader.load(page: page) {[weak self] result in
            guard let `self` = self else {
                return
            }
            do {
                let imageItems = try result.get()
                self.storage.save(page: page, imageItems: imageItems)
                completion(.success(imageItems))
            } catch {
                completion(.failure(error))
            }
        }
    }
}
