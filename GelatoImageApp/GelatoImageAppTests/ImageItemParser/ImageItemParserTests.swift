//
//  ImageItemParserTests.swift
//  GelatoImageAppTests
//
//  Created by RN on 04/07/21.
//

import XCTest
@testable import GelatoImageApp

class ImageItemParserTests: XCTestCase {

    func test_loadWithHTTPStatusCodeNot200() throws {
        let samples = [199, 201, 300, 400, 500]
        try samples.enumerated().forEach { (_, code) in
            XCTAssertThrowsError(try ImageItemParser.parseData(nil, anyResponse(code: code)))
        }
    }

    func test_loadDataWith200StatusCodeAndEmptyItems() throws {
        let emptyList: [Any] = []
        let data = try! JSONSerialization.data(withJSONObject: emptyList, options: .prettyPrinted)
        let items = try ImageItemParser.parseData(data, anyResponse)
        XCTAssertEqual(items, [])
    }

    func test_loadDataWith200StatusCodeAndNonEmptyValidItems() throws {
        let item1 = makeImageItem()
        let item2 = makeImageItem()
        let item3 = makeImageItem()
        let item4 = makeImageItem()

        let item1Dict = makeImageDict(from: item1)
        let item2Dict = makeImageDict(from: item2)
        let item3Dict = makeImageDict(from: item3)
        let item4Dict = makeImageDict(from: item4)

        let rootObject = [item1Dict, item2Dict, item3Dict, item4Dict]
        let data = try! JSONSerialization.data(withJSONObject: rootObject, options: .prettyPrinted)

        let items = try ImageItemParser.parseData(data, anyResponse)
        XCTAssertEqual(items, [item1, item2, item3, item4])
    }

    func makeImageDict(from item: ImageItem) -> [String: Any?] {
        var imageDict: [String: Any?] = [String: Any?]()
        imageDict["id"] = item.id
        imageDict["url"] = item.url.absoluteString
        imageDict["download_url"] = item.download_url.absoluteString
        imageDict["width"] = item.width
        imageDict["height"] = item.height
        imageDict["author"] = item.author
        return imageDict
    }
}
