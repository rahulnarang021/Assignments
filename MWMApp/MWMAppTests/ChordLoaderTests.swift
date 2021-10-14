//
//  ChordLoaderTests.swift
//  MWMAppTests
//
//  Created by RAHUL on 26/06/20.
//  Copyright © 2020 MWM. All rights reserved.
//

import XCTest
@testable import MWMApp


class ChordLoaderTests: XCTestCase {

    func test_chordLoaderCallsAPIMethodOnlyOnceWhenLoadMethodIsCalled() {
        let (sut, spy) = makeSUT()
        sut.loadResults(completion: { (_, _) in} )
        XCTAssertEqual(spy.makeAPICallCount, 1)
    }

    func test_imageFeedMethodPassesQuerySameQueryToNetworkingMethod() {
        let (sut, spy) = makeSUT()
       sut.loadResults(completion: { (_, _) in} )
        let trappedURL = spy.trappedConfiguration?.getUrl()// can create helper for these
        XCTAssertEqual(ChordResultAPIConstants.url, trappedURL?.absoluteString)
    }

    func test_imageFeedLoaderReturnsErrorWhenRequestFailedWithError() {
        let (sut, spy) = makeSUT()
        let expectedErrorMessage = "Something went wrong in test"
        var capturedMessage: String?
        sut.loadResults(completion: { (result, errorMessage) in
            capturedMessage = errorMessage
        })
        spy.completeWithError(message: expectedErrorMessage)
        XCTAssertEqual(expectedErrorMessage, capturedMessage)
    }

    func makeSUT() -> (ChordListLoader, APIManagerSpy) {
        let spy = APIManagerSpy()
        let loader = ChordListLoader(networking: spy)
        testMemorLeak(loader)
        return (loader, spy)
    }

    private func getChordResult() -> ChordResult {
        return ChordResult(allkeys: [], allchords: [])
    }

    private func testMemorLeak(_ sut: AnyObject?, file: StaticString = #file, line: UInt = #line) {
        addTeardownBlock {[weak sut] in
            XCTAssertNil(sut, "This variable is creating a retain cycle", file: file, line: line)
        }
    }
}

class APIManagerSpy: APIManagerInput {

    var makeAPICallCount: Int = 0
    var trappedConfiguration: APIConfiguration?
    var trappedCompletion: ((_ result: ChordResult?, _ error: MWMError?) -> Void)?

    func makeAPICall<T>(apiConfiguration: APIConfiguration, completion: @escaping ((APIResult<T>) -> ())) where T : Decodable {
        trappedConfiguration = apiConfiguration
        makeAPICallCount += 1
        trappedCompletion = {result, error in
            if let message = error {
                completion(.failure(error: message))
            } else if let result = result {
                completion(.success(response: result as! T))// if it fails then its a development failure in tests
            }
        }
    }

    func completeWithError(message: String) {
        trappedCompletion?(nil, MWMError(message: message))
    }

    func completeSuccessfullyWithResult(ChordResult: ChordResult) {
        trappedCompletion?(ChordResult, nil)
    }
}
