//
//  WeatherListViewModel.swift
//  WeatherApp
//
//  Created by Rahul Narang on 17/12/2021.
//

import Foundation
import Combine

class WeatherListViewModel: ObservableObject {

    var throttlingInSeconds: TimeInterval {
        0.5
    }

    @Published var cityName: String = ""

    @Published var listVM: [WeatherRowViewModel] = []

    private let weatherManager: WeatherManager

    private var disposables = Set<AnyCancellable>()

    init(weatherManager: WeatherManager) {
        self.weatherManager = weatherManager
        bindData()
    }

    func bindData() {
        $cityName
            .removeDuplicates()
            .debounce(for: .seconds(throttlingInSeconds), scheduler: DispatchQueue.main)
            .sink(receiveValue: { [weak self] city in
                self?.fetchWeather(for: city)
            })
            .store(in: &disposables)
    }

    private func fetchWeather(for city: String) {
        guard !city.isEmpty else {
            self.listVM = []
            return
        }
        weatherManager.loadWeather(for: city)
            .map { response in
                WeatherRowViewModelParser.parseWeatherInfo(weatherInfo: response)
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .failure(_):
                    self?.listVM = []
                case .finished:
                    break
                }
            } receiveValue: { [weak self] weatherRows in
                self?.listVM = weatherRows
            }
            .store(in: &disposables)
    }
}
