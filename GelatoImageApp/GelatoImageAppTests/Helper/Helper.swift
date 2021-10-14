//
//  Helper.swift
//  GelatoImageAppTests
//
//  Created by RN on 02/07/21.
//

import XCTest
@testable import GelatoImageApp

extension XCTestCase {

    var anyData: Data {
        return Data(count: 10)
    }
    
    var anyURL: URL {
        return URL(string: "http://a-given-url")!
    }

    var anyResponse: HTTPURLResponse {
        return HTTPURLResponse(url: anyURL, statusCode: 200, httpVersion: nil, headerFields: nil)!
    }

    var errorResponse: HTTPURLResponse {
        return HTTPURLResponse(url: anyURL, statusCode: 400, httpVersion: nil, headerFields: nil)!
    }

    var anyError: NSError {
        return NSError(domain: "SomeError", code: 1, userInfo: nil)
    }

    func testMemoryLeak(_ sut: AnyObject?, file: StaticString = #file, line: UInt = #line) {
        addTeardownBlock {[weak sut] in
            XCTAssertNil(sut, "This variable is creating a retain cycle", file: file, line: line)
        }
    }

    func anyResponse(code: Int) -> HTTPURLResponse {
        return HTTPURLResponse(url: anyURL, statusCode: code, httpVersion: nil, headerFields: nil)!
    }

    func makeImageItem(id: String = UUID().uuidString, author: String = "Author", width: Double = 300, height: Double = 300, url: URL = URL(string: "https://a-image-url.jpeg")!) -> ImageItem {
        return ImageItem(id: id,
                         author: author,
                         width: width,
                         height: height,
                         url: url,
                         download_url: url)
    }

    func dummyImageData(color: UIColor = .red) -> Data {
        return UIImage.make(withColor: color).jpegData(compressionQuality: 1)! // force unwrapping to set the right expectations in test
    }
}
