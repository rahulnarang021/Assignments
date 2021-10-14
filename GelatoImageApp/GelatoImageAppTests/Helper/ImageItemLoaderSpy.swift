//
//  ImageItemLoaderSpy.swift
//  GelatoImageAppTests
//
//  Created by RN on 06/07/21.
//

import Foundation
import GelatoImageApp

class ImageItemLoaderSpy: ImageItemLoader {

    var messages: [(ImageItemLoader.Result) -> Void] = []
    var messageCount: Int {
        return messages.count
    }

    func load(page: Int, completion: @escaping (ImageItemLoader.Result) -> Void) {
        messages.append(completion)
    }

    func completeLoadingWithSuccess(for items: [ImageItem], at index: Int = 0) {
        messages[index](.success(items))
    }

    func completeLoadingWithError(for error: NSError, at index: Int = 0) {
        messages[index](.failure(error))
    }

}
