//
//  URLProtocolSpy.swift
//  WeatherAppTests
//
//  Created by Rahul Narang on 17/12/2021.
//

import Foundation
class URLProtocolSpy: URLProtocol {
    static private var stub: Stub?
    static var observer: ((URLRequest) -> Void)?
    private struct Stub {
        var data: Data?
        var response: HTTPURLResponse?
        var error: Error?
    }

    class func startInterceptingRequest() {
        URLProtocol.registerClass(URLProtocolSpy.self)
    }

    class func stopInterceptingRequest() {
        URLProtocol.unregisterClass(URLProtocolSpy.self)
        stub = nil
        observer = nil
    }

    class func stubRequest(data: Data? = nil, response: HTTPURLResponse? = nil, error: Error? = nil) {
        stub = Stub(data: data, response: response, error: error)
    }

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }


    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        if let requestObserver = URLProtocolSpy.observer {
            client?.urlProtocolDidFinishLoading(self)
            requestObserver(request)
            return
        }
        if let data = URLProtocolSpy.stub?.data {
            client?.urlProtocol(self, didLoad: data)
        }
        if let response = URLProtocolSpy.stub?.response {
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        }
        if let error = URLProtocolSpy.stub?.error {
            client?.urlProtocol(self, didFailWithError: error)
        }
        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}
