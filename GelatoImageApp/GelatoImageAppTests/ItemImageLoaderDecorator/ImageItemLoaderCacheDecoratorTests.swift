//
//  ImageItemLoaderCacheDecoratorTests.swift
//  GelatoImageAppTests
//
//  Created by RN on 06/07/21.
//

import XCTest
import GelatoImageApp

class ImageItemLoaderCacheDecoratorTests: XCTestCase {

    func test_load_callsLoadItemsFromPrimarySource() {
        let sut = makeSUT()
        sut.decorator.load(page: 0) { _ in }
        XCTAssertEqual(sut.loader.messageCount, 1, "Expected to call primary loader once but got \(sut.loader.messageCount) instead")
    }

    func test_load_callsLoadMethodReturnResultsFromPrimarySourceIfSuccess() {
        let sut = makeSUT()
        let imageItems = [makeImageItem()]
        sut.decorator.load(page: 0) { result in
            switch result {
            case let .success(loadedImageItems):
                XCTAssertEqual(imageItems, loadedImageItems, "Expected imageItems on success but got \(loadedImageItems) instead")
                break
            case let .failure(error):
                XCTFail("Expected success but got failure with error: \(error) instead")
            }

        }
        sut.loader.completeLoadingWithSuccess(for: imageItems)
    }

    func test_load_returnFailureResultFromFallbackIfPrimaryFailed() {
        let sut = makeSUT()
        sut.decorator.load(page: 0) {[anyError] result in
            switch result {
            case let .success(loadedImageItems):
                XCTFail("Expected failure but got success with \(loadedImageItems) results instead")
                break
            case let .failure(error):
                XCTAssertEqual(error as NSError, anyError, "Expected to fail with error but got \(error) instead")
            }

        }
        sut.loader.completeLoadingWithError(for: anyError)
    }

    func test_load_callsSaveMethodOnStorageWithCorrectPageOnLoaderSuccess() {
        let sut = makeSUT()
        let imageItems = [makeImageItem()]
        sut.decorator.load(page: 0) { _ in }
        sut.loader.completeLoadingWithSuccess(for: imageItems)
        XCTAssertEqual(sut.storage.messages, [ImageItemStorageSpy.StorageMessages.messages(page: 0, imageItems: imageItems)], "Expected to pass save message with correct page but got \(sut.storage.messages) instead")
    }

    func test_load_callsDoNotCallSaveMethodOnStorageOnLoaderFailure() {
        let sut = makeSUT()
        sut.decorator.load(page: 0) { _ in }
        sut.loader.completeLoadingWithError(for: anyError)
        XCTAssertEqual(sut.storage.messages.count, 0, "Expected not to pass save message on failure but got \(sut.storage.messages) instead")
    }

    private func makeSUT() -> (loader: ImageItemLoaderSpy, storage: ImageItemStorageSpy, decorator: ImageItemLoaderCacheDecorator) {
        let loaderspy = ImageItemLoaderSpy()
        let storageSpy = ImageItemStorageSpy()
        let decorator = ImageItemLoaderCacheDecorator(loader: loaderspy, storage: storageSpy)
        testMemoryLeak(decorator)
        testMemoryLeak(storageSpy)
        testMemoryLeak(loaderspy)

        return (loader: loaderspy, storage: storageSpy, decorator: decorator)
    }

    private class ImageItemStorageSpy: ImageItemStorage {

        enum StorageMessages: Equatable {
            case messages(page: Int, imageItems: [ImageItem])
        }

        var messages: [StorageMessages] = []
        var messageCount: Int {
            return messages.count
        }

        func save(page: Int, imageItems: [ImageItem]) {
            messages.append(.messages(page: page, imageItems: imageItems))
        }
    }
}
