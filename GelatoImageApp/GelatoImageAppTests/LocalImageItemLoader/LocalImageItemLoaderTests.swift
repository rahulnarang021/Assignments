//
//  LocalImageItemLoaderTests.swift
//  GelatoImageAppTests
//
//  Created by RN on 05/07/21.
//

import XCTest
import GelatoImageApp

class LocalImageItemLoaderTests: XCTestCase {

    func test_saveImageItems_saveResponseInStorage() throws {
        let sut = makeSUT()
        let imageItems = [makeImageItem()]

        let encodableItems = try JSONEncoder().encode(imageItems)
        sut.imageItemStore.save(page: 0, imageItems: imageItems)
        let firstSavedItem = try  XCTUnwrap(sut.storage.savedMessages.first, "Expected 1 Storage call on save item but got \(sut.storage.savedMessages.count) instead")
        XCTAssertEqual(firstSavedItem.value, encodableItems, "Expected same imageItem to be passed in storage but got \(firstSavedItem.value) instead")
    }

    func test_saveImageItems_shouldPassDifferentKeyForDifferentPages()  throws {
        let sut = makeSUT()
        let imageItems = [makeImageItem()]

        sut.imageItemStore.save(page: 0, imageItems: imageItems)
        sut.imageItemStore.save(page: 1, imageItems: imageItems)
        sut.imageItemStore.save(page: 2, imageItems: imageItems)

        let allKeys = sut.storage.getSavedMessageKeys()
        let uniqueKeys = Set(allKeys)
        XCTAssertEqual(allKeys.count, uniqueKeys.count, "Expected Unique Key to be passed for all individual pages to save data but got only \(uniqueKeys) instead")
    }

    func test_load_fetchCorrectItemsFromStorage() {
        let sut = makeSUT()
        let imageItems = [makeImageItem()]
        sut.storage.stubbedData = imageItems
        sut.imageItemStore.load(page: 0) {result in
            switch result {
            case let .success(loadedImageItems):
                XCTAssertEqual(loadedImageItems, imageItems, "Expected \(imageItems) but got \(loadedImageItems) instead")
                break
            case let .failure(error):
                XCTFail("Expected to load success but got failure with error: \(error) instead")
            }
        }

    }

    func test_load_fetchCorrectItemsFromStorageAccordingToPages() {
        let sut = makeSUT()
        sut.storage.stubbedData = []
        sut.imageItemStore.load(page: 0) { _ in }
        sut.imageItemStore.load(page: 1) { _ in }
        sut.imageItemStore.load(page: 2) { _ in }

        let allKeys = sut.storage.getMessages
        let uniqueKeys = Set(allKeys)
        XCTAssertEqual(allKeys.count, uniqueKeys.count, "Expected Unique Key to be passed for all individual pages to get Data but got only \(uniqueKeys) instead")


    }
    func test_load_throwErrorOnEmptyLoad() {
        let sut = makeSUT()
        sut.imageItemStore.load(page: 0) {result in
            switch result {
            case let .success(loadedImageItems):
                XCTFail("Expected failure but got items: \(loadedImageItems) instead")
                break
            case let .failure(error):
                XCTAssertNotNil(error, "Expected load to fail with some error")
            }
        }

    }

    private func makeSUT() -> (storage: StorageSpy, imageItemStore: LocalImageItemLoader){
        let storageSpy = StorageSpy()
        let imageItemStorage = LocalImageItemLoader(storage: storageSpy)
        testMemoryLeak(imageItemStorage)
        testMemoryLeak(storageSpy)

        return (storage: storageSpy, imageItemStore: imageItemStorage)
    }

    private class StorageSpy: Storage {

        var savedMessages: [(key: String, value: Data)] = []
        var stubbedData: [Decodable] = []

        var getMessages: [String] = []
        func getData<T>(for key: String) -> T where T: Decodable {
            getMessages.append(key)
            return stubbedData as! T // force unwrapping as if it's crashing then there is some testing bug
        }

        func save<T>(data: T, for key: String) throws where T : Encodable {
            let encodableItems = try JSONEncoder().encode(data)
            savedMessages.append((key: key, value: encodableItems))
        }

        func getSavedMessageKeys() -> [String] {
            let keys = savedMessages.map { (key, value) -> String in
                return key
            }
            return keys
        }

    }
}
