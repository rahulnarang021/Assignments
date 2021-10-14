//
//  LocalImageDataLoader.swift
//  GelatoImageApp
//
//  Created by RN on 10/07/21.
//

import Foundation
public class LocalImageDataLoader: ImageDataLoader {

    let store: LocalStore
    public init(store: LocalStore) {
        self.store = store
    }

    private enum LocalImageDataLoaderError: Error {
        case cancelled
    }

    @discardableResult
    public func load(url: URL, completion: @escaping (Result<Data, Error>) -> Void) -> LoaderTask {
        let task = LocalFileLoaderTask()
        self.store.load(name: url.identifier) { [weak task] result in
            let isCancelledTask = task?.isCancelled ?? false
            if isCancelledTask {
                completion(.failure(LocalImageDataLoaderError.cancelled))
            } else {
                completion(result)
            }
        }
        return task
    }
}

class LocalFileLoaderTask: LoaderTask {
    var isCancelled = false
    func cancel() {
        isCancelled = true
    }
}
