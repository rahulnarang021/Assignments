//
//  WeatherRowView.swift
//  WeatherApp
//
//  Created by Rahul Narang on 17/12/2021.
//

import Foundation
import SwiftUI

struct WeatherRowView: View {
    var weatherRowViewModel: WeatherRowViewModel

    var body: some View {
        HStack {
            Text(weatherRowViewModel.title)
            Spacer()
            Text(weatherRowViewModel.description)
        }
        .frame(maxWidth: .infinity)
    }
}
