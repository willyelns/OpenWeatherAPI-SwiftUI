//
//  CurrentWeatherViewModel.swift
//  MVVM SwiftUI
//
//  Created by Will Xavier on 15/03/20.
//  Copyright © 2020 Willyelns Consulting and Development Services. All rights reserved.
//

import SwiftUI
import Combine

// Make CurrentWeatherViewModel conform to ObservableObject and Identifiable.
class CurrentWeatherViewModel: ObservableObject, Identifiable {
  
  // Expose an optional CurrentWeatherRowViewModel as the data source.
  @Published var dataSource: CurrentWeatherRowViewModel?
  
  let city: String
  private let weatherRepository: WeatherRepository
  private var disposables = Set<AnyCancellable>()
  
  init(city: String, weatherRepository: WeatherRepository) {
    self.weatherRepository = weatherRepository
    self.city = city
  }
  
  func refresh() {
    weatherRepository
    .currentWeatherForecast(forCity: city)
    // Transform new values to a CurrentWeatherRowViewModel as they come in the form of a CurrentWeatherForecastResponse.
      .map(CurrentWeatherRowViewModel.init)
      .receive(on: DispatchQueue.main)
    .sink(receiveCompletion: { [weak self] value in
      guard let self = self else {return}
      switch value {
      case .failure:
        self.dataSource = nil
      case .finished:
        break
      }
      }, receiveValue: { [weak self] weather in
        guard let self = self else { return }
        self.dataSource = weather
    })
      .store(in: &disposables)
  }
}

