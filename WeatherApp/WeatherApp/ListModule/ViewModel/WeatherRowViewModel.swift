//
//  File.swift
//  WeatherApp
//
//  Created by Rahul Narang on 17/12/2021.
//

import Foundation
struct WeatherRowViewModel: Identifiable, Equatable {
    var id: Int
    var title: String
    var description: String

    public init(id: Int, title: String, description: String) {
        self.id = id
        self.title = title
        self.description = description
    }
}
