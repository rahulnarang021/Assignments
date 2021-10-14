//
//  RemoteLoaderTests.swift
//  GelatoImageAppTests
//
//  Created by RN on 02/07/21.
//

import XCTest
import GelatoImageApp

class RemoteLoaderTests: XCTestCase {

    func test_requestedURLIsNotEmpty() {
        let sut = makeSUT()
        sut.remotedFeedLoader.load(page: 0) {_ in }
        XCTAssertFalse(sut.client.requestedURLs.isEmpty)
    }

    func test_requestedURLIsCorrect() {
        let client = HTTPClientSpy()
        let url: URL = URL(string: "https://dummy-url")!

        let pageUrl: URL = URL(string: "https://dummy-url?page=0")!
        let sut = makeSUT(url: url, client: client)
        sut.remotedFeedLoader.load(page: 0) {_ in }
        XCTAssertEqual(client.requestedURLs, [pageUrl])
    }

    func test_requestedURLIsLoadedTwice() {
        let client = HTTPClientSpy()
        let url: URL = URL(string: "https://dummy-url")!
        let pageUrl: URL = URL(string: "https://dummy-url?page=0")!
        let sut = makeSUT(url: url, client: client)
        sut.remotedFeedLoader.load(page: 0) {_ in }
        sut.remotedFeedLoader.load(page: 0) {_ in }
        XCTAssertEqual(client.requestedURLs, [pageUrl, pageUrl])
    }

    func test_loadWithNoConnectivityError() {
        let (sut, client) = makeSUT()
        expect(sut, toCompleteWithResult: .failure(RemoteLoader<String>.Error.noConnectivity), onAction: {
            let error = NSError(domain: "Dummy Error", code: 0, userInfo: nil)
            client.complete(withError: error)
        })
    }

    func test_loadDataWith200StatusCodeAndInvalidData() {
        let (sut, client) = makeSUT(mapper: {_, _ in
            throw RemoteLoader<String>.Error.invalidData
        })
        expect(sut, toCompleteWithResult: .failure(RemoteLoader<String>.Error.invalidData), onAction: {
            let invalidJSON = Data(count: 10)
            client.complete(withStatusCode: 200, data: invalidJSON)
        })
    }

    func test_loadDataWith200StatusCodeAndValidData() {
        let resource = "a resource"
        let (sut, client) = makeSUT(mapper: {data, _ in
            String(data: data!, encoding: .utf8)!
        })
        expect(sut, toCompleteWithResult: .success(resource), onAction: {
            let validResourceData = resource.data(using: .utf8)!
            client.complete(withStatusCode: 200, data: validResourceData)
        })
    }

    func test_RemoteLoaderDoesnotInvokeBlockAfterDeallocation() {
        let client = HTTPClientSpy()
        var sut: RemoteLoader<String>? = RemoteLoader<String>(url: URL(string: "https://a-dummy-url")!, client: client, mapper: {_, _ in
            throw RemoteLoader<String>.Error.invalidData
        })
        var captureResult: [RemoteLoader<String>.ResultType] = []
        sut?.load(page: 0, completion: { captureResult.append($0) })
        sut = nil
        client.complete(withStatusCode: 200)
        XCTAssertTrue(captureResult.isEmpty)
    }

    //MARK: - Helpers

    private func makeSUT(url: URL = URL(string: "https://dummy-url")!,
                         client: HTTPClientSpy = HTTPClientSpy(),
                         mapper: @escaping RemoteLoader<String>.Mapper = {_, _ in
                            return "anyString"
                         }) -> (remotedFeedLoader: RemoteLoader<String>, client: HTTPClientSpy) {
        let sut = RemoteLoader<String>(url: url, client: client, mapper: mapper)
        testMemoryLeak(sut)
        testMemoryLeak(client)
        return (remotedFeedLoader: sut, client: client)
    }

    private func expect(_ sut: RemoteLoader<String>, toCompleteWithResult expectedResult: RemoteLoader<String>.ResultType, onAction action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        sut.load(page: 0) {[expectedResult] receivedResult in
            switch(receivedResult, expectedResult) {
            case let (.success(receivedItems), .success(expectedItems)):
                XCTAssertEqual(receivedItems, expectedItems)
            case let (.failure(receivedError as RemoteLoader<String>.Error), .failure(expectedError as RemoteLoader<String>.Error)):
                XCTAssertEqual(receivedError, expectedError)
            default:
                XCTFail("Results are mismatched")
            }
        }
        action()
    }
}

