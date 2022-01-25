//
//  RemoteWeatherManagerTests.swift
//  WeatherAppTests
//
//  Created by Rahul Narang on 17/12/2021.
//

import Foundation
import Combine
import XCTest
@testable import WeatherApp

class RemoteWeatherManagerTests: XCTestCase {
    
    func test_loadWeather_callsClientOnLoad() {
        let sut = makeSUT()
        let _ = sut.weatherManager.loadWeather(for: anyLocation)
        XCTAssertFalse(sut.client.requestedURLs.isEmpty)
    }
    
    func test_loadWeather_callsClientOnLoad_withCorrectCity() throws {
        let sut = makeSUT()
        let _ = sut.weatherManager.loadWeather(for: anyLocation)
        let requestedUrl = try XCTUnwrap(sut.client.requestedURLs.first)
        XCTAssertEqual(anyLocation, getCity(from: requestedUrl))
    }

    func test_loadWeather_whenClientReturnsError_shouldThrowError() {
        let sut = makeSUT()
        let publisher = sut.weatherManager.loadWeather(for: anyLocation)
        let spy = PublisherSpy(publisher)
        let remoteError = anyError
        sut.client.complete(withError: remoteError)
        XCTAssertTrue(!spy.errors.isEmpty)
    }
    
    func test_loadWeather_whenClientReturns200WithInvalidData_shouldThrowError() throws {
        let sut = makeSUT()
        let publisher = sut.weatherManager.loadWeather(for: anyLocation)
        let spy = PublisherSpy(publisher)
        sut.client.complete(withStatusCode: 200, data: anyData)
        let error = try XCTUnwrap(spy.errors.first as? WeatherInfoParser.WeatherError)

        XCTAssertEqual(error, WeatherInfoParser.WeatherError.invalidData)
    }

    func test_loadWeather_whenClientReturns200WithValidData_shouldReturnCorrectResponse() {
        let sut = makeSUT()
        let publisher = sut.weatherManager.loadWeather(for: anyLocation)
        let spy = PublisherSpy(publisher)
        sut.client.complete(withStatusCode: 200, data: weatherData)
        XCTAssertEqual(spy.results, [weatherInfo()])
    }

    func test_loadWeather_whenRemoteLoaderIsDeallocated_shouldInvokePublisher() {
        let client = HTTPClientSpy()
        var weatherManager: RemoteWeatherManager? = RemoteWeatherManager(client: client)
        if let publisher = weatherManager?.loadWeather(for: anyLocation) {
            let spy = PublisherSpy(publisher)
            weatherManager = nil
            client.complete(withStatusCode: 200, data: anyData)
            XCTAssertTrue(spy.errors.isEmpty)
        }

    }
    
    private var anyLocation: String {
        "anyLocation"
    }
    
    private func makeSUT() -> (weatherManager: RemoteWeatherManager, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let weatherManager = RemoteWeatherManager(client: client)
        testMemoryLeak(weatherManager)
        testMemoryLeak(client)
        return (weatherManager: weatherManager, client: client)
    }
    
    private func getCity(from url: URL) -> String? {
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        guard let queryItems = components?.queryItems, !queryItems.isEmpty else {
            return nil
        }
        guard let cityItem = queryItems.filter({ $0.name == "q" }).first else {
            return nil
        }
        return cityItem.value
    }

    private var weatherData: Data {
        try! JSONEncoder().encode(weatherInfo()) // force unwrapping here as it should always pass otherwise it's a crash and should be fixed during the development
    }

}
