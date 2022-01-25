//
//  WeatherListView.swift
//  WeatherApp
//
//  Created by Rahul Narang on 17/12/2021.
//

import Foundation
import SwiftUI

struct WeatherListView: View {
    @ObservedObject var viewModel: WeatherListViewModel

    var body: some View {
        VStack(alignment: .leading) {
            searchView
            dataView
        }
        Spacer()
    }

    private var searchView: some View {
        SearchBar(placeholder: "Search Location", text: $viewModel.cityName)
    }

    private var dataView: some View {
        VStack {
            if viewModel.listVM.isEmpty {
                emptySection
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
            } else {
                listView
            }
        }
    }

    var listView: some View {
        List {
            ForEach(viewModel.listVM) {
                WeatherRowView(weatherRowViewModel: $0)
                    .padding(EdgeInsets(top: 10, leading: 0, bottom: 5, trailing: 0))
                    .listRowInsets(EdgeInsets())
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.zero)
    }

    private var emptySection: some View {
        Section {
          Text("No results")
            .foregroundColor(.gray)
        }
      }
}
