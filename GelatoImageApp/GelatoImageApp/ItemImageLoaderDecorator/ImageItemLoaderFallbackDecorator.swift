//
//  ImageItemLoaderFallbackDecorator.swift
//  GelatoImageApp
//
//  Created by RN on 06/07/21.
//

import Foundation

public class ImageItemLoaderFallbackDecorator: ImageItemLoader {
    private let primary: ImageItemLoader
    private let fallback: ImageItemLoader

    public init(primary: ImageItemLoader, fallback: ImageItemLoader) {
        self.primary = primary
        self.fallback = fallback
    }

    public func load(page: Int, completion: @escaping (ImageItemLoader.Result) -> Void) {
        primary.load(page: page) {[weak self] result in
            guard let `self` = self else {
                return
            }
            do {
                let imageItems = try result.get()
                completion(.success(imageItems))

            } catch {
                self.fallback.load(page: page, completion: completion)
            }

        }
    }
}
