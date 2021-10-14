//
//  ImageItemParser.swift
//  GelatoImageApp
//
//  Created by RN on 02/07/21.
//

import Foundation
final public class ImageItemParser {
    class public func parseData(_ data: Data?, _ response: HTTPURLResponse) throws -> [ImageItem]  {
        guard let data = data, isValidResponse(response) else {
            throw Error.invalidData
        }
        do {
            let imageItems = try JSONDecoder().decode([ImageItem].self, from: data)
            return imageItems
        } catch {
            throw Error.invalidData
        }
    }

    public enum Error: Swift.Error, Equatable {
        case invalidData
    }

    private struct Root: Decodable  {
        let items: [ImageItem]
    }

    class func isValidResponse(_ response: HTTPURLResponse) -> Bool {
        return response.statusCode == 200
    }

}
