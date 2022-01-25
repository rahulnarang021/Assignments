//
//  WeatherDataModel.swift
//  WeatherApp
//
//  Created by Rahul Narang on 17/12/2021.
//

import Foundation
public struct WeatherInfo: Codable, Equatable {
    var coordinate: Coordinates
    var weather: [Weather]
    var dayInfo: DayInfo // can make these variables as optional if parsing fails
    var windInfo: WindInfo
    var main: WeatherData

    private enum CodingKeys: String, CodingKey {
        case coordinate = "coord"
        case weather
        case main
        case dayInfo = "sys"
        case windInfo = "wind"
    }
}

public struct Coordinates: Codable, Equatable {
    var latitude: Double
    var longitude: Double

    private enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lon"
    }

}

public struct WeatherData: Codable, Equatable {
    var normalTemperature: Double?
    var feelsLikeTemperature: Double?
    var minimumTemperature: Double?
    var maximumTemperature: Double?
    var pressure: Int
    var humidity: Int

    private enum CodingKeys: String, CodingKey {
        case normalTemperature = "temp"
        case feelsLikeTemperature = "feels_like"
        case minimumTemperature = "temp_min"
        case maximumTemperature = "temp_max"
        case pressure
        case humidity
    }

}

public struct Weather: Codable, Equatable {
    var id: Int
    var main: String
    var description: String
    var icon: String
}

public struct DayInfo: Codable, Equatable {
    var sunrise: TimeInterval
    var sunset: TimeInterval
}

public struct WindInfo: Codable, Equatable {
    var speed: Double
}
