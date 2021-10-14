//
//  XCTAssert+MemoryLeak.swift
//  DevicePerformanceAppTests
//
//  Created by RN on 14/05/21.
//

import Foundation
import XCTest

extension XCTestCase {
    func testMemoryLeak(value: AnyObject?, file: StaticString = #file, line: UInt = #line) {
        addTeardownBlock { [weak value] in
            XCTAssertNil(value, "Expected nil value but got \(String(describing: value)) instead", file: file, line: line)
        }
    }
}
