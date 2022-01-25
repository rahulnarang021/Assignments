//
//  WeatherManager.swift
//  WeatherApp
//
//  Created by Rahul Narang on 17/12/2021.
//

import Foundation
import Combine

public protocol WeatherManager {
    func loadWeather(for location: String) -> AnyPublisher<WeatherInfo, Error>
}
