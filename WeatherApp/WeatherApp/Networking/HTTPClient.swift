//
//  HTTPClient.swift
//  WeatherApp
//
//  Created by Rahul Narang on 17/12/2021.
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
