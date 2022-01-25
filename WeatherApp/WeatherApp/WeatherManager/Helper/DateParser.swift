//
//  DateParser.swift
//  WeatherApp
//
//  Created by Rahul Narang on 17/12/2021.
//

import Foundation
class DateParser {
    static var shared = DateParser()

    private(set) lazy var dateFormatter: DateFormatter = {
      let formatter = DateFormatter()
      formatter.dateStyle = .none
      formatter.timeStyle = .short
      formatter.locale = Locale(identifier: "en_US")
      return formatter
    }()

    func parseSunriseTime(date: Date) -> String {
        return dateFormatter.string(from: date)
    }
}
