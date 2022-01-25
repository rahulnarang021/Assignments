//
//  Helper.swift
//  WeatherAppTests
//
//  Created by Rahul Narang on 17/12/2021.
//

import XCTest
@testable import WeatherApp

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

    func weatherInfo() -> WeatherInfo {
        let coordinate = Coordinates(latitude: 23, longitude: 24)
        let weather = Weather(id: 1, main: "Cloud", description: "Cloudy desc", icon: "IconName")

        let dayInfo = DayInfo(sunrise: 1639814528, sunset: 1639842732)

        let main = WeatherData(normalTemperature: nil, feelsLikeTemperature: 3, minimumTemperature: 3, maximumTemperature: 4, pressure: 23, humidity: 23)

        let windInfo = WindInfo(speed: 2.3)
        return WeatherInfo(coordinate: coordinate, weather: [weather], dayInfo: dayInfo, windInfo: windInfo, main: main)
    }

    func weatherRowViewModels() -> [WeatherRowViewModel] {
        let row1 = WeatherRowViewModel(id: 0, title: "Cloud", description: "Cloudy desc")
        let row2 = WeatherRowViewModel(id: 1, title: "Temperature", description: "Min: 3.0 °C\nMax: 4.0 °C")
        let row3 = WeatherRowViewModel(id: 2, title: "Wind", description: "2.3 m/s")
        let row4 = WeatherRowViewModel(id: 3, title: "DayInfo", description: "Sunrise: 12:02 AM\nSunset: 7:52 AM")
        return [row1, row2, row3, row4]
    }
}
