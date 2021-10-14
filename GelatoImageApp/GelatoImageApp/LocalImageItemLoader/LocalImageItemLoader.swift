//
//  LocalImageItemLoader.swift
//  GelatoImageApp
//
//  Created by RN on 05/07/21.
//

import Foundation
public class LocalImageItemLoader: ImageItemStorage, ImageItemLoader {

    private enum LocalImageItemLoaderError: Error {
        case dataNotFound
    }

    private let storage: Storage
    public init(storage: Storage) {
        self.storage = storage
    }

    public func save(page: Int, imageItems: [ImageItem]) {
        do {
            try storage.save(data: imageItems, for: "serverResponse \(page)")
        } catch {
            print("Handle Error Here")
        }
    }

    public func load(page: Int, completion: @escaping (ImageItemLoader.Result) -> Void) {
        if let existingValue: [ImageItem] = storage.getData(for: "serverResponse \(page)"), existingValue.count > 0 {
            completion(.success(existingValue))
        } else {
            completion(.failure(LocalImageItemLoaderError.dataNotFound))
        }

    }
}
