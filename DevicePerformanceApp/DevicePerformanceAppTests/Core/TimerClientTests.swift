//
//  NotificationManagerClientTests.swift
//  DevicePerformanceAppTests
//
//  Created by RN on 13/05/21.
//

import XCTest
import DevicePerformanceApp

class TimerClientTests: XCTestCase {

    func test_init_shouldNotStartTimer() {
        let interval = 0.1
        let exp = expectation(description: "Timer Expectation")
        var messageCount = 0
        let _ = makeSUT(interval: interval) {
            messageCount += 1
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
            XCTAssertTrue(messageCount == 0, "Expected 0 messageCount but got \(messageCount) instead")
            exp.fulfill()
        }
        wait(for: [exp], timeout: interval)
    }

    func test_start_shouldStartTimerOfDesiredInterval() {
        let interval = 0.2
        let exp = expectation(description: "Timer Expectation")
        let sut = makeSUT(interval: interval) {
            exp.fulfill()
        }
        sut.start()
        wait(for: [exp], timeout: interval)
    }

    func test_start_shouldCallTimerMultipleTimesOnDesiredInterval() {
        let interval = 0.2
        let expecationCount = 2
        let exp = expectation(description: "Multiple Timer Expecation")
        exp.expectedFulfillmentCount = expecationCount
        let sut = makeSUT(interval: interval) {
            exp.fulfill()
        }
        sut.start()
        wait(for: [exp], timeout: (interval * Double(expecationCount)))
    }

    func test_stop_shouldStopTimer() {
        let interval = 0.2
        let exp = expectation(description: "Multiple Timer Expecation")
        var messageCount = 0
        let sut = makeSUT(interval: interval) {
            exp.fulfill()
            messageCount += 1
        }
        sut.start()
        DispatchQueue.main.asyncAfter(deadline: .now() + interval) { [weak sut] in
            sut?.stop()
        }
        wait(for: [exp], timeout: interval)

    }

    func makeSUT(interval: TimeInterval, action: @escaping () -> Void, file: StaticString = #file, line: UInt = #line)  -> TimerService {
        let service = TimerService(periodicInterval: interval, action: action)
        testMemoryLeak(value: service, file: file, line: line)
        return service
    }

}
