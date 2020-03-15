//
//  WeeklyWeatherView.swift
//  MVVM SwiftUI
//
//  Created by Will Xavier on 15/03/20.
//  Copyright © 2020 Willyelns Consulting and Development Services. All rights reserved.
//

import SwiftUI
import Combine

struct WeeklyWeatherView: View {
  
  @ObservedObject var viewModel: WeeklyWeatherViewModel
  
  init(viewModel: WeeklyWeatherViewModel) {
    self.viewModel = viewModel
  }
  
  var body: some View {
    NavigationView {
      List {
        searchField
        
        if(viewModel.dataSource.isEmpty){
          emptySection
        } else {
          cityHourlyWeatherSection
          forecastSection
        }
      }
      .listStyle(GroupedListStyle())
      .navigationBarTitle("Weather ⛅️")
    }
  }
}

private extension WeeklyWeatherView {
  var searchField: some View {
    HStack(alignment: .center) {
      // 1. $viewModel.city establishes a connection between the values you’re typing in the TextField and the WeeklyWeatherViewModel‘s city property. Using $ allows you to turn the city property into a Binding<String>. This is only possible because WeeklyWeatherViewModel conforms to ObservableObject and is declared with the @ObservedObject property wrapper.
      TextField("e.g Cupertino", text: $viewModel.city)
    }
  }
  
  var forecastSection: some View {
    Section {
      // 2. Initialize the daily weather forecast rows with their own ViewModels. Open DailyWeatherRow.swift to see how it works.
      ForEach(viewModel.dataSource, content: DailyWeatherRow.init(viewModel: ))
    }
  }
  
  var cityHourlyWeatherSection: some View {
    Section {
      NavigationLink(destination: viewModel.currentWeatherView) {
        VStack(alignment: .leading) {
            // 3. You can still use and access the WeeklyWeatherViewModel properties without any fancy binds. This just displays the city name in a Text.
          Text(viewModel.city)
          Text("Weather Today")
            .font(.caption)
            .foregroundColor(.gray)
        }
      }
    }
  }
  
  var emptySection: some View {
    Section {
      Text("No results")
        .foregroundColor(.gray)
    }
  }
}
