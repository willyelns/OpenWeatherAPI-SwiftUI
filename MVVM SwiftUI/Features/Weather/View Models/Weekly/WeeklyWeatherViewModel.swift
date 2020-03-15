//
//  WeeklyWeatherViewModel.swift
//  MVVM SwiftUI
//
//  Created by Will Xavier on 15/03/20.
//  Copyright © 2020 Willyelns Consulting and Development Services. All rights reserved.
//

import SwiftUI
import Combine


// Use the ObservableObject to turn the ViewModel bindlible
class WeeklyWeatherViewModel: ObservableObject, Identifiable {
  
  // The @Published delegate is used to turn the variable observable
  @Published var city: String = ""
  
  // keep all the data in the ViewModel, with the delagete, all the time when the data changed,
  // the view will be redraw
  @Published var dataSource: [DailyWeatherRowViewModel] = []
  
  private let weatherRepository: WeatherRepository
  
  // Think of disposables as a collection of references to requests.
  // Without keeping these references, the network requests you’ll make won’t be kept alive,
  // preventing you from getting responses from the server.
  private var disposables = Set<AnyCancellable>()
  
  // Add a scheduler parameter, so you can specify which queue the HTTP request will use.
  init(weatherRepository: WeatherRepository, scheduler: DispatchQueue = DispatchQueue(label: "WeatherViewModel")) {
    self.weatherRepository = weatherRepository
    
    // The city property uses the @Published property delegate so it acts like any other Publisher. This means it can be observed and can also make use of any other method that is available to Publisher.
    $city
    //  As soon as you create the observation, $city emits its first value. Since the first value is an empty string, you need to skip it to avoid an unintended network call.
    .dropFirst(1)
    // Use debounce(for:scheduler:) to provide a better user experience. Without it the fetchWeather would make a new HTTP request for every letter typed. debounce works by waiting half a second (0.5) until the user stops typing and finally sending a value. You also pass scheduler as an argument, which means that any value emitted will be on that specific queue. Rule of thumb: You should process values on a background queue and deliver them on the main queue.
    .debounce(for: .seconds(0.5), scheduler: scheduler)
    // You observe these events via sink(receiveValue:) and handle them with fetchWeather(forCity:) that you previously implemented.
    .sink(receiveValue: fetchWeather(forCity: ))
    // Finally, you store the cancelable as you did before.
    .store(in: &disposables)
  }
  
  func fetchWeather(forCity city: String) {
    
    // A new request to the API passing city as the argument
    weatherRepository.weeklyWeatherForecast(forCity: city)
      .map { response in
        //  Map the response (WeeklyForecastResponse object) to an array of DailyWeatherRowViewModel objects. This entity represents a single row in the list. You can check the implementation located in DailyWeatherRowViewModel.swift. With MVVM, it’s paramount for the ViewModel layer to expose to the View exactly the data it will need. It doesn’t make sense to expose directly to the View a WeeklyForecastResponse, since this forces the View layer to format the model in order to consume it. It’s a good idea to make the View as dumb as possible and concerned only with rendering.
        response.list.map(DailyWeatherRowViewModel.init)
    }
    // The OpenWeatherMap API returns multiple temperatures for the same day depending on the time of the day, so remove the duplicates. You can check Array+Filtering.swift to see how that’s done.
    .map(Array.removeDuplicates)
    // Although fetching data from the server, or parsing a blob of JSON, happens on a background queue, updating the UI must happen on the main queue. With receive(on:), you ensure the update you do in steps 5, 6 and 7 occurs in the right place.
    .receive(on: DispatchQueue.main)
    
    // Start the publisher via sink(receiveCompletion:receiveValue:). This is where you update dataSource accordingly. It’s important to notice that handling a completion — either a successful or failed one — happens separately from handling values.
    .sink(
      receiveCompletion:{ [weak self] value in
        guard let self = self else {return}
        switch value {
        case .failure:
          // In the event of a failure, set dataSource as an empty array.
          self.dataSource = []
        case .finished:
          break
        }
      },
      receiveValue: { [weak self] forecast in
        guard let self = self else {return}
        
        // Update dataSource when a new forecast arrives.
        self.dataSource = forecast
      })
      // Finally, add the cancellable reference to the disposables set. As previously mentioned, without keeping this reference alive, the network publisher will terminate immediately.
      .store(in: &disposables)
  }
}

extension WeeklyWeatherViewModel {
  var currentWeatherView: some View {
    return WeeklyWeatherBuilder.makeCurrentWeatherView(withCity: city, weatherRepository: weatherRepository)
  }
}
