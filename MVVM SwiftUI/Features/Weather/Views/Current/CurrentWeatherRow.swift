//
//  CurrentWeatherRow.swift
//  MVVM SwiftUI
//
//  Created by Will Xavier on 15/03/20.
//  Copyright © 2020 Willyelns Consulting and Development Services. All rights reserved.
//

import SwiftUI

struct CurrentWeatherRow: View {
  private let viewModel: CurrentWeatherRowViewModel
  
  init(viewModel: CurrentWeatherRowViewModel) {
    self.viewModel = viewModel
  }
  
  var body: some View {
    VStack(alignment: .leading) {
      MapView(coordinate: viewModel.coordinate)
        .cornerRadius(25)
        .frame(height: 300)
        .disabled(true)
      
      VStack(alignment: .leading) {
        HStack {
          Text("☀️ Temperature:")
          Text("\(viewModel.temperature)°")
            .foregroundColor(.gray)
        }
        
        HStack {
          Text("📈 Max temperature:")
          Text("\(viewModel.maxTemperature)°")
            .foregroundColor(.gray)
        }
        
        HStack {
          Text("📉 Min temperature:")
          Text("\(viewModel.minTemperature)°")
            .foregroundColor(.gray)
        }
        
        HStack {
          Text("💧 Humidity:")
          Text(viewModel.humidity)
            .foregroundColor(.gray)
        }
      }
    }
  }
}
