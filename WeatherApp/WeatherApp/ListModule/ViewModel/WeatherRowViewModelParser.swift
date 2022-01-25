//
//  WeatherRowViewModelParser.swift
//  WeatherApp
//
//  Created by Rahul Narang on 18/12/2021.
//

import Foundation

struct WeatherRowViewModelParser {
    static func parseWeatherInfo(weatherInfo: WeatherInfo) -> [WeatherRowViewModel] {
        var rowViewModels: [WeatherRowViewModel] = []
        var row = 0
        if let weather = weatherInfo.weather.first {
            let rowViewModel = WeatherRowViewModel(id: row, title: weather.main, description: weather.description)
            rowViewModels.append(rowViewModel)
            row += 1

        }
        if let minTemp = weatherInfo.main.minimumTemperature, let maxTemp = weatherInfo.main.maximumTemperature {
            let temperatureRow = WeatherRowViewModel(id: row, title: "Temperature", description: "Min: \(minTemp) °C\nMax: \(maxTemp) °C")
            rowViewModels.append(temperatureRow)

            row += 1

        }

        let windRow = WeatherRowViewModel(id: row, title: "Wind", description: "\(weatherInfo.windInfo.speed) m/s")
        rowViewModels.append(windRow)

        row += 1


        let sunrise = DateParser.shared.parseSunriseTime(date: Date(timeIntervalSince1970: weatherInfo.dayInfo.sunrise))
        let sunset = DateParser.shared.parseSunriseTime(date: Date(timeIntervalSince1970: weatherInfo.dayInfo.sunset))
        let dailyInfoRow = WeatherRowViewModel(id: row, title: "DayInfo", description: "Sunrise: \(sunrise)\nSunset: \(sunset)")
        // parsed directly from api response which seems to be wrong, issue may be related to different timezones that can be fixed by passing timezone in DateParser
        rowViewModels.append(dailyInfoRow)
        return rowViewModels
    }
}
