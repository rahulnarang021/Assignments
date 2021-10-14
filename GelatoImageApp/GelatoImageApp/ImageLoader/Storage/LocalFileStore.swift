//
//  LocalStore.swift
//  GelatoImageApp
//
//  Created by RN on 10/07/21.
//

import Foundation
public class LocalFileStore: LocalStore, ImageDataStorage {

    public typealias OperationCompletionBlock = (Error?) -> Void

    private let storeURL: URL

    private let queue = DispatchQueue(label: "\(LocalFileStore.self)Queue", qos: .userInitiated) // bydefault serial queue

    public init(storeURL: URL) {
        self.storeURL = storeURL
    }

    public func load(name: String, completion: @escaping (Result<Data, Error>) -> Void) {
        let imageUrlPath = self.imageUrlPath(name)
        queue.async {
            do {
                let data = try Data(contentsOf: imageUrlPath)
                completion(.success(data))
            } catch {
                completion(.failure(error))
            }
        }
    }

    public func save(name: String, data: Data, completion:  @escaping OperationCompletionBlock) {
        let imageUrlPath = self.imageUrlPath(name)
        queue.async {
            do {
                try data.write(to: imageUrlPath)
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }

    private func imageUrlPath(_ name: String) -> URL {
        let imageUrlPath = self.storeURL.appendingPathComponent("\(name).jpg")
        return imageUrlPath
    }
}
