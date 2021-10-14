//
//  ImageDataCompresionDecorator.swift
//  GelatoImageApp
//
//  Created by RN on 12/07/21.
//

import Foundation
import UIKit

class ImageDataCompresionDecorator: ImageDataCompressionLoader, ImageDataLoader {

    let imageDataLoader: ImageDataLoader
    init(imageDataLoader: ImageDataLoader) {
        self.imageDataLoader = imageDataLoader
    }

    func load(url: URL, completion: @escaping (Result<Data, Error>) -> Void) -> LoaderTask {
        return self.imageDataLoader.load(url: url, completion: completion)
    }

    func load(url: URL, compressionSize: CGSize? = nil, completion: @escaping (Result<Data, Error>) -> Void) -> LoaderTask {
        guard let pointSize = compressionSize else {
            return self.imageDataLoader.load(url: url, completion: completion)
        }
        return self.imageDataLoader.load(url: url) {[weak self] result in
            guard let `self` = self else {
                return
            }
            do {
                let imageData = try result.get()
                completion(.success(self.downSample(data: imageData, pointSize: pointSize)))
            } catch {
                completion(.failure(error))
            }
        }
    }

    private func downSample(data: Data, pointSize: CGSize) -> Data {
        let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
        let imageSource = CGImageSourceCreateWithData(data as CFData, imageSourceOptions)!

        let maxDimensionInPixels = max(pointSize.width, pointSize.height)

        let downsampledOptions = [kCGImageSourceCreateThumbnailFromImageAlways: true,
                                  kCGImageSourceShouldCacheImmediately: true,
                                  kCGImageSourceCreateThumbnailWithTransform: true,
                                  kCGImageSourceThumbnailMaxPixelSize: maxDimensionInPixels] as CFDictionary
        if let downsampledImage =     CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampledOptions) {
            return UIImage(cgImage: downsampledImage).jpegData(compressionQuality: 1)! // force unwrapping here but appropriate error should be handled
        }
        return data

    }
}
