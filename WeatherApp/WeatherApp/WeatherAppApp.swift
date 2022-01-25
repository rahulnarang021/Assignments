//
//  WeatherApp.swift
//  WeatherApp
//
//  Created by Rahul Narang on 17/12/2021.
//

import SwiftUI

@main
struct WeatherAppApp: App {
    var body: some Scene {
        WindowGroup {
            WeatherListViewComposer.composeView()
                .onAppear { // done that to reset UITableView background color
                    UITableView.appearance().backgroundColor = .white
                }
        }
    }
}
