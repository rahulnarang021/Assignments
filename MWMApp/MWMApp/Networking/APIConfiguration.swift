//
//  APIConfiguration.swift
//  MWMApp
//
//  Created by RAHUL on 19/06/20.
//  Copyright © 2020 MWM. All rights reserved.
//

import Foundation
protocol APIConfiguration {//  Used by APIManager to make api call
    func getGetParams() -> [String: String?]?
    func getHeaders() -> [String: String]?
    func getUrl() -> URL
    func getRequestType() -> RequestType
    func getRequestTimeout() -> TimeInterval
    func getPostParams() -> [String: Any?]?
}
