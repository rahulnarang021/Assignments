//
//  UserdefaultsLocalStorageTests.swift
//  DevicePerformanceAppTests
//
//  Created by RN on 13/05/21.
//

import XCTest
import DevicePerformanceApp

class LocalMetricClientTests: XCTestCase {


    func test_saveThreshold_shouldPassSaveMessageToStorage() {
        let sut = makeSUT()
        let dummyValue = 3
        let type = MetricType.battery
        sut.client.saveNewThreshold(value: dummyValue, type: type)
        XCTAssertTrue(sut.storage.messages.count > 0, "Client i not passing value to storage. It contains 0 messages but expected \(sut.storage.messages.count) message(s) instead")
    }

    func test_saveThreshold_shouldPassMultipleMessageToStorageOnCalledMultipleTimes() {
        let sut = makeSUT()
        let dummyValue = 3
        for _ in 1...dummyValue {
            let type = MetricType.battery
            sut.client.saveNewThreshold(value: dummyValue, type: type)
        }
        XCTAssertTrue(sut.storage.messages.count == dummyValue, "Client i not passing value to storage. It contains 0 messages but expected \(sut.storage.messages.count) message(s) instead")
    }

    func test_saveThreshold_shouldSaveCorrectValue() throws {
        let sut = makeSUT()
        let dummyValue = 3
        let type = MetricType.battery
        sut.client.saveNewThreshold(value: dummyValue, type: type)
        let value = try XCTUnwrap(sut.storage.messages.first?.value as? Int)

        XCTAssertEqual(value, dummyValue, "Saved value: \(value) should be equal to the passed value: \(dummyValue)")
    }

    func test_saveThreshold_shouldSaveAgainstCorrectKey() throws {
        let sut = makeSUT()
        let dummyValue = 3
        let type = MetricType.battery
        sut.client.saveNewThreshold(value: dummyValue, type: type)
        let key = try XCTUnwrap(sut.storage.messages.first?.key)
        XCTAssertEqual(key, KeyParser.thresholdKey(type: type), "Saved Key: \(key) should be equal to the passed value: \(KeyParser.thresholdKey(type: type))")
    }

    func test_saveAlert_shouldSaveCorrectStatus() throws {
        let sut = makeSUT()
        let dummyValue = true
        let type = MetricType.battery
        sut.client.saveAlertStatus(value: dummyValue, for: type)
        let value = try XCTUnwrap(sut.storage.messages.first?.value as? Bool)

        XCTAssertEqual(value, dummyValue, "Saved value: \(value) should be equal to the passed value: \(dummyValue)")
    }

    func test_saveAlert_shouldSaveAgainstCorrectKey() throws {
        let sut = makeSUT()
        let dummyValue = true
        let type = MetricType.battery
        sut.client.saveAlertStatus(value: dummyValue, for: type)
        let key = try XCTUnwrap(sut.storage.messages.first?.key)
        XCTAssertEqual(key, KeyParser.alertKey(type: type), "Saved Key: \(key) should be equal to the passed value: \(KeyParser.alertKey(type: type))")
    }

    func test_saveRecoveryAlert_shouldSaveCorrectStatus() throws {
        let sut = makeSUT()
        let dummyValue = true
        let type = MetricType.battery
        sut.client.saveRecoveryAlertStatus(value: dummyValue, for: type)
        let value = try XCTUnwrap(sut.storage.messages.first?.value as? Bool)

        XCTAssertEqual(value, dummyValue, "Saved value: \(value) should be equal to the passed value: \(dummyValue)")
    }

    func test_saveRecoveryAlert_shouldSaveAgainstCorrectKey() throws {
        let sut = makeSUT()
        let dummyValue = true
        let type = MetricType.battery
        sut.client.saveRecoveryAlertStatus(value: dummyValue, for: type)
        let key = try XCTUnwrap(sut.storage.messages.first?.key)
        XCTAssertEqual(key, KeyParser.recoveryAlertKey(type: type), "Saved Key: \(key) should be equal to the passed value: \(KeyParser.alertKey(type: type))")
    }

    func test_saveAlert_shouldChangeValueOnMultipleCalls() throws {
        let sut = makeSUT()
        var dummyValue = true
        let type = MetricType.battery
        sut.client.saveAlertStatus(value: dummyValue, for: type)

        dummyValue.toggle()
        sut.client.saveAlertStatus(value: dummyValue, for: type)

        let value = try XCTUnwrap(sut.storage.messages.last?.value as? Bool)
        XCTAssertEqual(value, dummyValue, "Saved value: \(value) should be equal to the passed value: \(dummyValue)")
    }

    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (client: MetricConfigurationClient, storage: LocalStorageSpy) {
        let storageSpy = LocalStorageSpy()
        let client = LocalMetricConfigurationClient(storage: storageSpy)
        testMemoryLeak(value: client, file: file, line: line)
        testMemoryLeak(value: storageSpy, file: file, line: line)
        return (client: client, storage: storageSpy)
    }


}

fileprivate class LocalStorageSpy: LocalStorage {

    var messages: [(key: String, value: Any?)] = []

    func saveValue<T>(_ value: T, for key: String) where T : Encodable {
        messages.append((key: key, value: value))
    }

    func getValue<T>(for key: String) -> T? where T : Decodable {
        for index in messages.count-1...0 {
            let message = messages[index]
            if message.key == key {
                return (message.value as? T)
            }
        }
        return nil
    }
}
