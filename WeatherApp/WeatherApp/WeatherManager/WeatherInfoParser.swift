//
//  WeatherInfoParser.swift
//  WeatherApp
//
//  Created by Rahul Narang on 17/12/2021.
//

import Foundation
public enum WeatherInfoParser {
    
    public enum WeatherError: Error, Equatable {
        case invalidData
    }

    static func parseData(_ data: Data?, _ response: HTTPURLResponse) throws -> WeatherInfo  {
        guard let data = data, isValidResponse(response) else {
            throw WeatherError.invalidData
        }
        do {
            let weatherInfo = try JSONDecoder().decode(WeatherInfo.self, from: data)
            return weatherInfo
        } catch {
            throw WeatherError.invalidData
        }
    }
    
    static func isValidResponse(_ response: HTTPURLResponse) -> Bool {
        return response.statusCode == 200
    }
}
