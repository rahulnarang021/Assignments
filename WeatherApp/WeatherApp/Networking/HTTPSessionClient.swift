//
//  HTTPSessionClient.swift
//  WeatherApp
//
//  Created by Rahul Narang on 17/12/2021.
//

import Foundation
public class HTTPSessionClient: HTTPClient {
    var session: URLSession
    public init(session: URLSession = URLSession.shared) {
        self.session = session
    }

    private struct UnexpectedError: Error {

    }
    
    private final class HTTPSessionTask: HTTPClientTask {
        var wrapped: URLSessionDataTask
        init(value: URLSessionDataTask) {
            self.wrapped = value
        }
        
        func cancel() {
            wrapped.cancel()
        }
    }
    
    public func get(url: URL,  completion:@escaping (HTTPClientResultType) -> Void) -> HTTPClientTask {
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            }
            else if let unwrappedData = data, let unwrappedResponse = response as? HTTPURLResponse {
                completion(.success(unwrappedData, unwrappedResponse))
            }
            else {
                completion(.failure(UnexpectedError()))
            }
        }
        task.resume()
        return (HTTPSessionTask(value: task))
    }
}
