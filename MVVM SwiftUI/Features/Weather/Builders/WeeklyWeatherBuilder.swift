//
//  WeeklyWeatherBuilder.swift
//  MVVM SwiftUI
//
//  Created by Will Xavier on 15/03/20.
//  Copyright © 2020 Willyelns Consulting and Development Services. All rights reserved.
//

import SwiftUI

enum WeeklyWeatherBuilder {
  static func makeCurrentWeatherView(
    withCity city: String,
    weatherRepository: WeatherRepository
  ) -> some View {
    let viewModel = CurrentWeatherViewModel(city: city, weatherRepository: weatherRepository)
    
    return CurrentWeatherView(viewModel: viewModel)
  }
}
