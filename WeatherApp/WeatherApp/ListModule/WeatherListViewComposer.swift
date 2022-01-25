//
//  WeatherListViewComposer.swift
//  WeatherApp
//
//  Created by Rahul Narang on 17/12/2021.
//

import Foundation
enum WeatherListViewComposer { // created enum as it's instance is not created anywhere but can be changed if needed
    static func composeView() -> WeatherListView {
        let client = HTTPSessionClient()
        let weatherManager = RemoteWeatherManager(client: client)
        let viewModel = WeatherListViewModel(weatherManager: weatherManager)
        let view = WeatherListView(viewModel: viewModel)
        return view
    }
}
