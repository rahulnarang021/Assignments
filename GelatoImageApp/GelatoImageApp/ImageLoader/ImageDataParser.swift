//
//  ImageDataParser.swift
//  GelatoImageApp
//
//  Created by RN on 09/07/21.
//

import Foundation

class ImageDataParser {
    class public func parseData(_ data: Data?, _ response: HTTPURLResponse) throws -> Data  {
        guard let data = data, isValidResponse(response) else {
            throw Error.invalidData
        }
        return data
    }

    public enum Error: Swift.Error, Equatable {
        case invalidData
    }

    class func isValidResponse(_ response: HTTPURLResponse) -> Bool {
        return response.statusCode == 200
    }

}
