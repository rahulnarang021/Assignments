//
//  HTTPClient.swift
//  GelatoImageApp
//
//  Created by RN on 02/07/21.
//

import Foundation

public enum HTTPClientResultType {
    case success(Data?, HTTPURLResponse)
    case failure(Error)
}

public protocol HTTPClientTask {
    func cancel()
}

public protocol HTTPClient {
    @discardableResult
    func get(url: URL, completion:@escaping (HTTPClientResultType) -> Void) -> HTTPClientTask
}
