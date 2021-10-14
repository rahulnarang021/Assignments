//
//  HTTPClientSpy.swift
//  GelatoImageAppTests
//
//  Created by RN on 02/07/21.
//

import Foundation
import GelatoImageApp

class HTTPClientSpy: HTTPClient {
    
    var requestedURLs: [URL] {
        captureList.map { $0.url }
    }

    var captureList: [(url: URL, completion: (HTTPClientResultType) -> Void)] = []
    var cancelURLs: [URL] = []
    private class HTTPClientTaskSpy: HTTPClientTask {
        var cancelClosure: (() -> Void)?
        
        init(completion: (() -> Void)?) {
            self.cancelClosure = completion
        }
        
        func cancel() {
            self.cancelClosure?()
        }
    }
    
    func get(url: URL, completion:@escaping (HTTPClientResultType) -> Void)  -> HTTPClientTask {
        let message = (url, completion)
        captureList.append(message)
        return HTTPClientTaskSpy {[weak self] in
            self?.cancelURLs.append(url)
        }
    }

    func complete(withError error: Error, atIndex index: Int = 0) {
        captureList[index].completion(.failure(error))
    }

    func complete(withStatusCode code: Int, data: Data = Data(), atIndex index: Int = 0) {
        let response = HTTPURLResponse(url: requestedURLs[index], statusCode: code, httpVersion: nil, headerFields: nil)!
        captureList[index].completion(.success(data, response))
    }
}
