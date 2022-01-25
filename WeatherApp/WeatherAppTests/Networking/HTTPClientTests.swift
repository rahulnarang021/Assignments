//
//  HTTPClientTests.swift
//  WeatherAppTests
//
//  Created by Rahul Narang on 17/12/2021.
//

import Foundation
import XCTest
import WeatherApp

class HTTPClientTests: XCTestCase {

    override func setUp() {
        super.setUp()
        URLProtocolSpy.startInterceptingRequest()
    }

    override func tearDown() {
        super.tearDown()
        URLProtocolSpy.stopInterceptingRequest()
    }

    func test_getFromURL_callsTheCorrectURL() {
        let url = anyURL
        URLProtocolSpy.stubRequest(error: anyError)
        URLProtocolSpy.observer = { request in
            XCTAssertEqual(request.url!, url)
        }
        let exp = expectation(description: "Wait for request to be completed")

        makeSUT().get(url: url) {_ in
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }

    func test_getFromURL_failsOnRequestError() {
        let error = anyError
      XCTAssertEqual(error.domain, (resultErrorFor(data: nil, response: nil, error: error)! as NSError).domain)
    }

    func test_getFromURL_whenCalledWithInvalidPaths_returnError() {
        XCTAssertNotNil(resultErrorFor(data: nil, response: nil, error: nil))
        XCTAssertNotNil(resultErrorFor(data: anyData, response: nil, error: nil))
        XCTAssertNotNil(resultErrorFor(data: anyData, response: anyResponse, error: anyError))
    }

    func test_getFromURL_whenFinishesSuccesfully_returnsSuccess() {
        let data = anyData
        let response = anyResponse
        let values = resultValuesFor(data: data, response: response, error: nil)
        XCTAssertEqual(values!.0, data)
        XCTAssertEqual(values!.1!.statusCode, response.statusCode)
        XCTAssertEqual(values!.1!.url, response.url!)
    }

    // MARK: - Helper Methods
    private func resultErrorFor(data: Data?, response: HTTPURLResponse?, error: Error?, file: StaticString = #file, line: UInt = #line) -> Error? {
        URLProtocolSpy.stubRequest(data: data, response: response, error: error)
        let exp = expectation(description: "Wait for request to be completed")
        var capturedError: Error?
        makeSUT().get(url: anyURL) { result in
            switch result {
            case .failure(let failedError):
                capturedError = failedError
            default:
                break
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
        return capturedError
    }

    private func resultValuesFor(data: Data?, response: HTTPURLResponse?, error: Error?, file: StaticString = #file, line: UInt = #line) -> (Data?, HTTPURLResponse?)? {
        URLProtocolSpy.stubRequest(data: data, response: response, error: error)
        let exp = expectation(description: "Wait for request to be completed")
        var capturedValues: (data: Data?, response: HTTPURLResponse?)?
        makeSUT().get(url: anyURL) { result in
            switch result {
            case let .success(data, response):
                capturedValues = (data: data, response: response)

            default:
                break
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
        return capturedValues
    }

    private func makeSUT() -> HTTPClient {
        return HTTPSessionClient()
    }

    
}

