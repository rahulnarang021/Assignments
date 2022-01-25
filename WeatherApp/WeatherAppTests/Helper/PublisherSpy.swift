//
//  PublisherSpy.swift
//  WeatherAppTests
//
//  Created by Rahul Narang on 17/12/2021.
//

import Foundation
import Combine

class PublisherSpy<T> {
    var results: [T] = []
    var errors: [Error] = []
    var disposables: Set<AnyCancellable> = Set<AnyCancellable>()
    init(_ publisher: AnyPublisher<T, Error>) {
        publisher.sink { [weak self] completion in
            switch completion {
            case let .failure(error):
                self?.errors.append(error)
            case .finished:
                break
            }
        } receiveValue: { [weak self] value in
            self?.results.append(value)
        }
        .store(in: &disposables)
    }
}
