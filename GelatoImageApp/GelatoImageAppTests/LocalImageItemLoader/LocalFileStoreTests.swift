//
//  LocalFileStoreTests.swift
//  GelatoImageAppTests
//
//  Created by RN on 10/07/21.
//

import XCTest
import GelatoImageApp
class LocalFileStoreTests: XCTestCase {

    private var testSpecificStoreUrl: URL {
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!.appendingPathComponent(String(describing: Self.self))
    }

    override func tearDown() {
        super.tearDown()
        clearDisk()
    }

    override func setUp() {
        super.setUp()
        createTestDirectory()
        clearDisk()
    }

    func createTestDirectory() {
        try! FileManager.default.createDirectory(at: testSpecificStoreUrl, withIntermediateDirectories: true, attributes: nil)
    }

    func clearDisk() {
        do {
            try FileManager.default.removeItem(atPath: testSpecificStoreUrl.absoluteString)
        } catch {
            print(error)
        }
    }

    func test_retrieveEmptyCacheReturnsError() {
        let sut = makeSUT()
        self.loadCache(sut: sut, name: "uniqueImageName", expectedResult: .failure(anyError))
    }

    func test_retrieveEmptyCacheTwiceReturnsEmpty() {
        let sut = makeSUT()
        self.loadCache(sut: sut, name: "uniqueImageName", expectedResult: .failure(anyError))
        self.loadCache(sut: sut, name: "uniqueImageName", expectedResult: .failure(anyError))
    }

    func test_operationsAreExecutedSerially() {
        let sut = makeSUT()
        let data = dummyImageData()

        var operations: [XCTestExpectation] = []

        let op1 = expectation(description: "Wait for save cache to complete")
        sut.save(name: "Image1", data: data) {_ in
            operations.append(op1)
            op1.fulfill()
        }

        let op2 = expectation(description: "Wait for load cache to complete")
        sut.load(name: "Image2") {_ in
            operations.append(op2)
            op2.fulfill()
        }

        wait(for: [op1, op2], timeout: 3.0)

        XCTAssertEqual([op1, op2], operations)
    }

    func test_insertInEmptyStoreReturnsNonEmptyData() {
        let sut = makeSUT()
        let data = dummyImageData()

        let error = save(data: data, from: dummyImageNameKey, in: sut)

        XCTAssertNil(error, "Expected empty but got \(error!) instead")

        loadCache(sut: sut, name: dummyImageNameKey, expectedResult: .success(data))
    }

    func test_insertInEmptyStoreReturnsNonEmptyDataTwiceWithNoSideEffects() {
        let sut = makeSUT()
        let data = dummyImageData()

        let error = save(data: data, from: dummyImageNameKey, in: sut)

        XCTAssertNil(error, "Expected empty but got \(error!) instead")

        loadCache(sut: sut, name: dummyImageNameKey, expectedResult: .success(data))
        loadCache(sut: sut, name: dummyImageNameKey, expectedResult: .success(data))
    }

    func test_retrieveMethodReturnsErrorWhenThereIsInValidData() {
        let url = testSpecificStoreUrl
        let sut = makeSUT(storeURL: url)
        insertInValidData(inUrl: url)
        loadCache(sut: sut, name: "uniqueImageName", expectedResult: .failure(anyError))
    }

    func test_retrieveMethodReturnsErrorTwiceWhenThereIsInValidData() {
        let url = testSpecificStoreUrl
        let sut = makeSUT(storeURL: url)
        insertInValidData(inUrl: url)
        loadCache(sut: sut, name: "uniqueImageName", expectedResult: .failure(anyError))
        loadCache(sut: sut, name: "uniqueImageName", expectedResult: .failure(anyError))
    }

    func test_insertionOverriodeTheAlreadyInsertedValues() {
        let sut = makeSUT()
        let oldData = dummyImageData(color: .red)
        let newData = dummyImageData(color: .green)
        let error = save(data: oldData, from: dummyImageNameKey, in: sut)

        XCTAssertNil(error, "Expected empty but got \(error!) instead")

        let latestError = save(data: newData, from: dummyImageNameKey, in: sut)
        XCTAssertNil(latestError, "Expected empty but got \(error!) instead")
        loadCache(sut: sut, name: dummyImageNameKey, expectedResult: .success(newData))

    }

    func test_fileSystemFailWhenInsertedInUnknownDirectory() {
        let url = URL(string: "/path/to/file")
        let sut = makeSUT(storeURL: url)
        let error = save(data: dummyImageData(), from: dummyImageNameKey, in: sut)
        XCTAssertNotNil(error)
    }

    // MARK: Helper Methods
    func makeSUT(storeURL: URL? = nil, file: StaticString = #file, line: UInt = #line) -> LocalFileStore {
        let store = LocalFileStore(storeURL: storeURL ?? self.testSpecificStoreUrl)
        testMemoryLeak(store)
        return store
    }

    func insertInValidData(inUrl url: URL) {
        try? "Invalaid data".write(to: url, atomically: true, encoding: .utf8)
    }

    func save(data: Data, from name: String, in sut: LocalFileStore) -> Error? {
        var capturedError: Error?
        let exp = expectation(description: "Wait to save value in file")
        sut.save(name: name, data: data) { error in
            capturedError = error
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
        return capturedError
    }

    func loadCache(sut: LocalFileStore, name: String = "DummyImage", expectedResult: Result<Data, Error>, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "wait for cache result")
        sut.load(name: name) { result in
            switch (result, expectedResult) {
            case (.failure, .failure):
                break
            case let (.success(data), .success(expectedData)):
                XCTAssertEqual(data, expectedData, file: file, line: line)
            default:
                XCTFail("Result do not match", file: file, line: line)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }

    private var dummyImageNameKey: String {
        return "DummyImage"
    }

}
