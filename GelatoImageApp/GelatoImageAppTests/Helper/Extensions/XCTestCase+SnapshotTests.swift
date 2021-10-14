//
//  XCTestCase+SnapshotTests.swift
//  GelatoImageAppTests
//
//  Created by RN on 12/07/21.
//

import XCTest

extension XCTestCase {
    func assert(viewController: UIViewController, name: String, file: StaticString = #file, line: UInt = #line) {
        guard let snapshotData = viewController.snapshot(for: iPhone8LightConfiguration()).pngData() else {
            XCTFail("Failed to convert snapshot to snapshotdata", file: file, line: line)
            return
        }
        let snapshotDirectoryUrl = URL(fileURLWithPath: "\(file)")
        .deletingPathExtension()

        let snapshotFileUrl = snapshotDirectoryUrl
        .appendingPathComponent(name)
        .appendingPathExtension("jpg")

        let existingFileData = try? Data(contentsOf: snapshotFileUrl)
        XCTAssert(snapshotData == existingFileData, "Snapshot of file: \(name) doesnot match")

    }

    func record(viewController: UIViewController, name: String, file: StaticString = #file, line: UInt = #line) {
        guard let snapshotData = viewController.snapshot(for: SnapshotConfiguration.iPhone8(style: .light)).pngData() else {
            XCTFail("Failed to convert snapshot to snapshotdata", file: file, line: line)
            return
        }
        let snapshotDirectoryUrl = URL(fileURLWithPath: "\(#file)")
        .deletingPathExtension()

        let snapshotFileUrl = snapshotDirectoryUrl
        .appendingPathComponent(name)
        .appendingPathExtension("jpg")

        do {
            try FileManager.default.createDirectory(at: snapshotDirectoryUrl, withIntermediateDirectories: true, attributes: nil)

            try snapshotData.write(to: snapshotFileUrl)
        } catch {
            XCTFail("Failed to write snapshot fileData to url: \(snapshotFileUrl) and error: \(error.localizedDescription)", file: file, line: line)
        }
    }

    func iPhone8LightConfiguration() -> SnapshotConfiguration {
        return SnapshotConfiguration.iPhone8(style: .light)
    }
}
