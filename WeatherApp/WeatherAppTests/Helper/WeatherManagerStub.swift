//
//  WeatherManagerSpy.swift
//  WeatherAppTests
//
//  Created by Rahul Narang on 17/12/2021.
//

import Foundation
import WeatherApp
import Combine

class WeatherManagerStub: WeatherManager {

    var passthroughSubject = PassthroughSubject<WeatherInfo, Error>()

    var captureList: [String] = []
    func loadWeather(for location: String) -> AnyPublisher<WeatherInfo, Error> {
        captureList.append(location)
        return passthroughSubject.eraseToAnyPublisher()
    }

    func loadWeatherWithSuccess(weatherInfo: WeatherInfo) {
        passthroughSubject.send(weatherInfo)
    }

    func loadWeatherWithError(error: Error) {
        passthroughSubject.send(completion: .failure(error))
    }

}
