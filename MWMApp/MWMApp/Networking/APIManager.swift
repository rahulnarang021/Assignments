//
//  AppInitApiWrapper.swift
//  MWMApp
//
//  Created by RAHUL on 19/06/20.
//  Copyright © 2020 MWM. All rights reserved.
//

import Foundation

struct ApiConstants {
    static let contentType: String = "Content-Type"
    static let accept: String = "Accept"
    static let applicationJson: String = "application/json"
    static let parsingError: String = "Unable to parse the response"
}

struct MWMError {// created custom error object to be passed on views and handle custom errors dfrom api
    var code: Int?
    var message: String

    init(error: Error?) {
        message = error?.localizedDescription ?? "Something went wrong"
    }

    init(message: String) {
        self.message = message
    }
}

enum RequestType: String {
    case GET = "GET";
    case POST = "POST";
    case PUT = "PUT";
    case DELETE = "DELETE";
}

enum APIResult<T: Decodable> { // Used to return response
    case success(response: T)
    case failure(error: MWMError)
}

class APIManager: APIManagerInput {// Class to make API Call
    static let shared: APIManager = APIManager()

    func makeAPICall<T: Decodable>(apiConfiguration: APIConfiguration, completion: @escaping ((APIResult<T>) -> ())) {
        var request = URLRequest(url: apiConfiguration.getUrl().getURLAddingGetParams(params: apiConfiguration.getGetParams()), cachePolicy: .reloadIgnoringCacheData, timeoutInterval: apiConfiguration.getRequestTimeout())

        let urlSession = URLSession.shared
        request.httpMethod = apiConfiguration.getRequestType().rawValue
        if let postparams = apiConfiguration.getPostParams() {
            let jsonData = try? JSONSerialization.data(withJSONObject: postparams)
            request.httpBody = jsonData
        }

        request.addValue(ApiConstants.applicationJson, forHTTPHeaderField: ApiConstants.contentType)
        request.addValue(ApiConstants.applicationJson, forHTTPHeaderField: ApiConstants.accept)
        if let headers = apiConfiguration.getHeaders(), headers.count > 0 {
            for apiHeader in headers {
                request.addValue(apiHeader.value, forHTTPHeaderField: apiHeader.key)
            }
        }
        do {
            let task = urlSession.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
                if let httpResponse: HTTPURLResponse = response as? HTTPURLResponse, httpResponse.isSuccess(), let jsonData = data {
                    do {
                        let jsonDecoder = JSONDecoder()
                        let response: T = try jsonDecoder.decode(T.self, from: jsonData)// decode data
                        DispatchQueue.main.async {
                            completion(.success(response: response))
                        }
                    } catch {// not handling error would be used to log somewhere
                        DispatchQueue.main.async {
                            completion(.failure(error: MWMError(message: ApiConstants.parsingError)))
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(.failure(error: MWMError(error: error)))
                    }
                }
            }
            task.resume()
        }
    }
}

extension HTTPURLResponse {
    func isSuccess() -> Bool {
        return (statusCode >= 200 && statusCode < 400)// failure check
    }
}

extension URL {
    func getURLAddingGetParams(params: [String: String?]?) -> URL {// add Get params in url
        guard let getParams = params else {
            return self // return default for no params
        }
        if var urlComponents: URLComponents = URLComponents(url: self, resolvingAgainstBaseURL: false) {
            var queryItems: [URLQueryItem] = []
            for param in getParams {
                if let value = param.value, param.key.count > 0 {
                    let queryItem: URLQueryItem = URLQueryItem(name: param.key, value: value)
                    queryItems.append(queryItem)
                }
            }
            urlComponents.queryItems = queryItems
            if let url = urlComponents.url {
                return url
            }
        }
        return self // return default for urlComponent creation failure
    }
}
