//
//  URL+GetParams.swift
//  GelatoImageApp
//
//  Created by RN on 06/07/21.
//

import Foundation
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
