//
//  ImageDataLoaderFallbackDecorator.swift
//  GelatoImageApp
//
//  Created by RN on 11/07/21.
//

import Foundation
import UIKit
public class ImageDataLoaderFallbackDecorator: ImageDataLoader {

    private let primary: ImageDataLoader
    private let fallback: ImageDataLoader

    public init(primary: ImageDataLoader, fallback: ImageDataLoader) {
        self.primary = primary
        self.fallback = fallback
    }

    @discardableResult
    public func load(url: URL, completion: @escaping (ImageDataLoader.Result) -> Void) -> LoaderTask {
        let task: ImageDecoratorTaskWrapper = ImageDecoratorTaskWrapper()
        let primaryTask = self.primary.load(url: url) { [weak self] result in
            guard let `self` = self else {
                return
            }
            do {
                let imageData = try result.get()
                completion(.success(imageData))

            } catch {
                let fallbackTask = self.fallback.load(url: url, completion: completion)
                task.appendTask(fallbackTask)
            }
        }
        task.appendTask(primaryTask)
        return task
    }

    private class ImageDecoratorTaskWrapper: LoaderTask {
        private var allTasks: [LoaderTask] = []

        func appendTask(_ task: LoaderTask) {
            allTasks.append(task)
        }

        func cancel() {
            allTasks.forEach { $0.cancel() }
        }
    }
}
