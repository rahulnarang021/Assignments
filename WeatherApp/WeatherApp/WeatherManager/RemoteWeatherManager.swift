//
//  RemoteWeatherManager.swift
//  WeatherApp
//
//  Created by Rahul Narang on 17/12/2021.
//

import Foundation
import Combine

class RemoteWeatherManager: WeatherManager {
    
    private let client: HTTPClient
    
    init(client: HTTPClient) {
        self.client = client
    }
    
    public func loadWeather(for location: String) -> AnyPublisher<WeatherInfo, Error> {
        let url = weatherUrl(for: location)
        return Future {[weak self] completion in
            self?.client.get(url: url) {[weak self] result in
                guard self != nil else { return }
                switch result {
                case let .success(data, response):
                    do {
                        let weatherInfo = try WeatherInfoParser.parseData(data, response)
                        completion(.success(weatherInfo))
                    } catch {
                        completion(.failure(error))
                    }
                case let .failure(error):
                    completion(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    private func weatherUrl(for location: String) -> URL {
        var url = URL(string: WeatherAPIConstants.url)!
        url = url.appendItem("q", value: location)
        url = url.appendItem("appid", value: WeatherAPIConstants.appId)
        url = url.appendItem("cnt", value: WeatherAPIConstants.count)
        url = url.appendItem("units", value: WeatherAPIConstants.units)
        return url
    }
}
