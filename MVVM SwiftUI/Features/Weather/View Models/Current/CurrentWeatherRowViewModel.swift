//
//  CurrentWeatherRowViewModel.swift
//  MVVM SwiftUI
//
//  Created by Will Xavier on 15/03/20.
//  Copyright © 2020 Willyelns Consulting and Development Services. All rights reserved.
//

import Foundation
import SwiftUI
import MapKit

struct CurrentWeatherRowViewModel {
  private let item: CurrentWeatherForecastResponse
  
  var temperature: String {
    return String(format: "%.1f", item.main.temperature)
  }
  
  var maxTemperature: String {
    return String(format: "%.1f", item.main.maxTemperature)
  }
  
  var minTemperature: String {
    return String(format: "%.1f", item.main.minTemperature)
  }
  
  var humidity: String {
    return String(format: "%.1f", item.main.humidity)
  }
  
  var coordinate: CLLocationCoordinate2D {
    return CLLocationCoordinate2D.init(latitude: item.coord.lat, longitude: item.coord.lon)
  }
  
  init(item: CurrentWeatherForecastResponse) {
    self.item = item
  }
}

