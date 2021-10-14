//
//  PerformancePresenterTests.swift
//  DevicePerformanceAppTests
//
//  Created by RN on 13/05/21.
//

import XCTest
import DevicePerformanceApp

class PerformanceViewPresenterTests: XCTestCase {

    func test_init_shouldCreate3Controller() {
        let sut = makeSUT()
        XCTAssertTrue(sut.presenter.controllers.count == 3, "Expected to create controller on init but got \(sut.presenter.controllers) instead")
    }

    func test_init_saveMessageShouldPassCorrectValueToClient() throws {
        let sut = makeSUT()

        let threshold = 20
        sut.presenter.didChangeThreshold(to: 20, type: .cpu)
        let savedValue = try XCTUnwrap(sut.client.savedThreshold[.cpu])

        XCTAssertTrue(savedValue == 20, "Expected to pass correct thresold i.e. \(threshold) to client but got \(savedValue) instead")
    }

    func test_init_saveMessageShouldPassCorrectStatusToClient() throws {
        let sut = makeSUT()

        sut.presenter.didEnableDisableAlert(isAlertOn: true, type: .cpu)
        let savedValue = try XCTUnwrap(sut.client.savedAlertStatus[.cpu])

        XCTAssertTrue(savedValue, "Expected to pass correct alert status i.e. \(savedValue) to client but got \(savedValue) instead")
    }

    
    func makeSUT(file: StaticString = #file, line: UInt = #line) -> (presenter: PerformanceViewPresenter, client: MetricClientStub) {
        let client = MetricClientStub()
        let presenter = PerformanceViewPresenter(client: client, alertClicked: { })
        testMemoryLeak(value: client, file: file, line: line)
        testMemoryLeak(value: presenter, file: file, line: line)
        return (presenter: presenter, client: client)
    }
}
