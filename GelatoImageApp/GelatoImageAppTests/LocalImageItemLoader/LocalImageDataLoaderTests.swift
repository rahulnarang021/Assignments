//
//  LocalImageDataLoaderTests.swift
//  GelatoImageAppTests
//
//  Created by RN on 11/07/21.
//

import XCTest
import GelatoImageApp

class LocalImageDataLoaderTests: XCTestCase {

    func test_loadFailedWithErrorShouldReturnError() {
        let (loader, spy) = makeSUT()
        expect(loader, toCompleteWithResult: .failure(anyError), url: makeURL()) {
            spy.complete(with: anyError)
        }
    }

    func test_loadSuccessWithDataShouldReturnData() {
        let (loader, spy) = makeSUT()
        let imageData = dummyImageData()
        expect(loader, toCompleteWithResult: .success(imageData), url: makeURL()) {
            spy.complete(with: imageData)
        }
    }

    func test_loadFailureOnTaskCancelled() {
        let (loader, spy) = makeSUT()
        let imageData = dummyImageData()

        let exp = expectation(description: "Wait for result")
        let task = loader.load(url: makeURL()) { receivedResult in
            switch receivedResult {
            case let .success(receivedData):
                XCTFail("Expected Failure but got success with \(receivedData) instead")
            case let .failure(receivedError):
                XCTAssertNotNil(receivedError, "Error should not be nil")
            }
            exp.fulfill()
        }
        task.cancel()
        spy.complete(with: imageData)
        wait(for: [exp], timeout: 1.0)
    }


    private func makeSUT() -> (loader: LocalImageDataLoader, spy: LocalStoreSpy) {
        let storeSpy = LocalStoreSpy()
        let localImageLoader = LocalImageDataLoader(store: storeSpy)
        testMemoryLeak(localImageLoader)
        testMemoryLeak(storeSpy)

        return (loader: localImageLoader, spy: storeSpy)
    }

    func makeURL() -> URL {
        return URL(string: "https://homepages.cae.wisc.edu/~ece533/images/airplane.png")!
    }

    @discardableResult
    private func expect(_ sut: LocalImageDataLoader, toCompleteWithResult expectedResult: Result<Data, Error>, url: URL, onAction action: () -> Void, file: StaticString = #file, line: UInt = #line) -> LoaderTask {
        let exp = expectation(description: "Wait for result")
        let task = sut.load(url: url) {receivedResult in
            switch(receivedResult, expectedResult) {
            case let (.success(receivedData), .success(expectedData)):
                XCTAssertEqual(receivedData, expectedData)
            case let (.failure(receivedError as NSError), .failure(expectedError as NSError)):
                XCTAssertEqual(receivedError, expectedError)
            default:
                XCTFail("Results are mismatched")
            }
            exp.fulfill()
        }
        action()
        wait(for: [exp], timeout: 1.0)
        return task
    }

    private class LocalStoreSpy: LocalStore {
        var messages: [(name: String, completion: ((Result<Data, Error>) -> Void))] = []
        var messageCount: Int {
            return messages.count
        }

        var requestedNames: [String] {
            return messages.map { $0.name }
        }

        func load(name: String, completion: @escaping (Result<Data, Error>) -> Void) {
            self.messages.append((name: name, completion: completion))
        }

        func complete(with data: Data, at index: Int = 0) {
            self.messages[index].completion(.success(data))
        }

        func complete(with error: Error, at index: Int = 0) {
            self.messages[index].completion(.failure(error))
        }

    }
}
