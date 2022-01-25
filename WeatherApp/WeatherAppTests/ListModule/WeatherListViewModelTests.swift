//
//  WeatherListViewModelTests.swift
//  WeatherAppTests
//
//  Created by Rahul Narang on 17/12/2021.
//

import Foundation
import Combine
import XCTest
@testable import WeatherApp
import SwiftUI

class WeatherListViewModelTests: XCTestCase {

    var disposable = Set<AnyCancellable>()
    func test_viewModel_whenInitialised_shouldLoadWithEmptyCity() {
        let sut = makeSUT()
        XCTAssertEqual(sut.viewModel.cityName, "")
    }

    func test_viewModel_whenInitialised_shouldNotLoadWeather() {
        let sut = makeSUT()
        XCTAssertTrue(sut.weatherManager.captureList.isEmpty)
    }

    func test_viewModel_whenSearchedWithLocation_shouldCallToLoadWeather() {
        let sut = makeSUT()

        let stringSubject = PassthroughSubject<String, Never>()
        stringSubject.assign(to: &sut.viewModel.$cityName)
        stringSubject.send("citiesName")

        expectOnMainQueue(timeout: sut.viewModel.throttlingInSeconds) {
            XCTAssertEqual(sut.weatherManager.captureList, ["citiesName"])
        }
    }

    func test_viewModel_whenSearchedWithEmptyLocation_shouldNotCallToLoadWeather() {
        let sut = makeSUT()

        let stringSubject = PassthroughSubject<String, Never>()
        stringSubject.assign(to: &sut.viewModel.$cityName)
        stringSubject.send("")

        expectOnMainQueue(timeout: sut.viewModel.throttlingInSeconds) {
            XCTAssertEqual(sut.weatherManager.captureList, [])
        }
    }

    func test_viewModel_whenSearchedWithDuplicateLastLocation_shouldNotCallToLoadWeather() {
        let sut = makeSUT()

        let stringSubject = PassthroughSubject<String, Never>()
        stringSubject.assign(to: &sut.viewModel.$cityName)
        stringSubject.send("cityName")
        stringSubject.send("cityName")

        expectOnMainQueue(timeout: sut.viewModel.throttlingInSeconds) {
            XCTAssertEqual(sut.weatherManager.captureList, ["cityName"])
        }
    }

    func test_viewModel_whenSearchedWithValidLocation_shouldAssignCorrectResults() {
        let sut = makeSUT()

        let stringSubject = PassthroughSubject<String, Never>()
        stringSubject.assign(to: &sut.viewModel.$cityName)
        stringSubject.send("cityName")

        var capturedResults: [[WeatherRowViewModel]] = []
        sut.viewModel.$listVM
            .sink { result in
                capturedResults.append(result)
            }
            .store(in: &self.disposable)

        let exp2 = expectation(description: "Wait for results")
        expectOnMainQueue(timeout: sut.viewModel.throttlingInSeconds) { [weak self] in
            guard let self = self else { return }
            let weatherInfo = self.weatherInfo()

            sut.weatherManager.loadWeatherWithSuccess(weatherInfo: weatherInfo)

            DispatchQueue.main.asyncAfter(deadline: .now() + sut.viewModel.throttlingInSeconds) { [weak self] in
                guard let self = self else { return }
                XCTAssertEqual(capturedResults, [[], self.weatherRowViewModels()])
                exp2.fulfill()
            }
        }
        wait(for: [exp2], timeout: sut.viewModel.throttlingInSeconds)

    }

    func test_viewModel_whenSearchedFailedWithError_shouldAssignEmptyResults() {
        let sut = makeSUT()

        let stringSubject = PassthroughSubject<String, Never>()
        stringSubject.assign(to: &sut.viewModel.$cityName)
        stringSubject.send("cityName")

        var capturedResults: [[WeatherRowViewModel]] = []
        sut.viewModel.$listVM
            .sink { result in
                capturedResults.append(result)
            }
            .store(in: &self.disposable)

        let exp2 = expectation(description: "Wait for results")
        expectOnMainQueue(timeout: sut.viewModel.throttlingInSeconds) { [weak self] in
            guard let self = self else {
                return
            }
            sut.weatherManager.loadWeatherWithError(error: self.anyError)

            DispatchQueue.main.asyncAfter(deadline: .now() + sut.viewModel.throttlingInSeconds) {
                XCTAssertEqual(capturedResults, [[], []])
                exp2.fulfill()
            }
        }
        wait(for: [exp2], timeout: sut.viewModel.throttlingInSeconds)

    }

    private func expectOnMainQueue(timeout: TimeInterval, completion: @escaping () -> Void) {
        let exp = expectation(description: "Wait for Main Queue Switch")

        DispatchQueue.main.asyncAfter(deadline: .now() + timeout) {
            completion()
            exp.fulfill()
        }
        wait(for: [exp], timeout: timeout)
    }

    func makeSUT() -> (viewModel: WeatherListViewModel, weatherManager: WeatherManagerStub) {
        let weatherManager = WeatherManagerStub()
        let viewModel = WeatherListViewModel(weatherManager: weatherManager)
        testMemoryLeak(viewModel)
        testMemoryLeak(weatherManager)
        return (viewModel: viewModel, weatherManager: weatherManager)
    }
    
}
