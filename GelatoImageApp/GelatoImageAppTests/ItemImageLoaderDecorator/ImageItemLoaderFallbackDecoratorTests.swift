//
//  ImageItemLoaderDecoratorTests.swift
//  GelatoImageAppTests
//
//  Created by RN on 06/07/21.
//

import XCTest
import GelatoImageApp

class ImageItemLoaderFallbackDecoratorTests: XCTestCase {

    func test_load_callsLoadItemsOnlyFromPrimarySourceFirst() {
        let sut = makeSUT()
        sut.decorator.load(page: 0) { _ in }
        XCTAssertEqual(sut.primary.messageCount, 1, "Expected to call primary loader once but got \(sut.primary.messageCount) instead")
        XCTAssertEqual(sut.fallback.messageCount, 0, "Expected not to call fallback loader but got \(sut.fallback.messageCount) instead")
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
        sut.primary.completeLoadingWithSuccess(for: imageItems)
    }

    func test_load_doesNotCallFallbackLoaderIfPrimaryReturnSuccess() {
        let sut = makeSUT()
        let imageItems = [makeImageItem()]
        let fallback = sut.fallback
        sut.decorator.load(page: 0) {[weak fallback] result in
            guard let fallback = fallback else {
                return
            }
            switch result {
            case .success(_):
                XCTAssertEqual(fallback.messageCount, 0, "Expected not to call fallback loader but got \(fallback.messageCount) instead")
                break
            case let .failure(error):
                XCTFail("Expected success but got failure with error: \(error) instead")
            }

        }
        sut.primary.completeLoadingWithSuccess(for: imageItems)
    }

    func test_load_callsFallbackLoaderInCasePrimaryLoaderFailed() {
        let sut = makeSUT()
        sut.decorator.load(page: 0) {_ in }
        sut.primary.completeLoadingWithError(for: anyError)
        XCTAssertEqual(sut.fallback.messageCount, 1, "Expected to call fallback loader but got \(sut.fallback.messageCount) instead")
    }

    func test_load_returnSuccessResultFromFallbackIfPrimaryFailed() {
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
        sut.primary.completeLoadingWithError(for: anyError)
        sut.fallback.completeLoadingWithSuccess(for: imageItems)
    }

    func test_load_returnFailureResultFromFallbackIfPrimaryFailed() {
        let sut = makeSUT()
        let fallbackError = NSError(domain: "fallbackError", code: 0, userInfo: nil)
        sut.decorator.load(page: 0) { result in
            switch result {
            case let .success(loadedImageItems):
                XCTFail("Expected failure but got success with \(loadedImageItems) results instead")
                break
            case let .failure(error):
                XCTAssertEqual(error as NSError, fallbackError, "Expected to fail with error but got \(error) instead")
            }

        }
        sut.primary.completeLoadingWithError(for: anyError)
        sut.fallback.completeLoadingWithError(for: fallbackError)
    }


    func makeSUT() -> (decorator: ImageItemLoaderFallbackDecorator, primary: ImageItemLoaderSpy, fallback: ImageItemLoaderSpy) {
        let primaryLoader = ImageItemLoaderSpy()
        let fallbackLoader = ImageItemLoaderSpy()
        let sut = ImageItemLoaderFallbackDecorator(primary: primaryLoader, fallback: fallbackLoader)
        testMemoryLeak(sut)
        testMemoryLeak(primaryLoader)
        testMemoryLeak(fallbackLoader)

        return (decorator: sut, primary: primaryLoader, fallback: fallbackLoader)
    }

    
}
