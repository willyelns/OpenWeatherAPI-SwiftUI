//
//  WeatherRepository.swift
//  MVVM SwiftUI
//
//  Created by Will Xavier on 15/03/20.
//  Copyright © 2020 Willyelns Consulting and Development Services. All rights reserved.
//

import Foundation
import Combine

protocol WeatherRepository {
  func weeklyWeatherForecast(forCity city: String) -> AnyPublisher<WeeklyForecastResponse, ApplicationError>
  
  func currentWeatherForecast(forCity city: String) -> AnyPublisher<CurrentWeatherForecastResponse, ApplicationError>
}


// MARK: - WeatherRepository
class WeatherRepositoryImpl: WeatherRepository {
  
  private let session: URLSession
  private let remoteDataSource: WeatherRemoteDataSource
  
    init(session: URLSession = .shared, remoteDataSource: WeatherRemoteDataSource) {
    self.session = session
    self.remoteDataSource = remoteDataSource
  }
  
  //  to display the weather forecast for the next five days.
  func weeklyWeatherForecast(forCity city: String) -> AnyPublisher<WeeklyForecastResponse, ApplicationError> {
    return forecast(with: remoteDataSource.makeWeeklyForecastComponents(withCity: city))
  }
  
  // You’ll use the second to view more detailed weather information.
  func currentWeatherForecast(forCity city: String) -> AnyPublisher<CurrentWeatherForecastResponse, ApplicationError> {
    return forecast(with: remoteDataSource.makeCurrentDayForecastComponents(withCity: city))
  }
  
  private func forecast<T>(with components: URLComponents) -> AnyPublisher<T, ApplicationError> where T: Decodable {
    
    // tries to create an instance of URL, if fails, return a fail value
    guard let url = components.url else {
        // TODO: Add a i8n here
      let error = ApplicationError.network(description: "Couldn't create URL")
      return Fail(error: error).eraseToAnyPublisher()
    }
    
    // uses the url session method to fetch the data. The method returns a tuple [Data, URLResponse] or an URLError
    return session.dataTaskPublisher(for: URLRequest(url: url))
      // To map the URLError to a WeatherError
      .mapError{ error in
        .network(description: error.localizedDescription)
      }
      // Uses the data from the server to a full object of the model, limited by .max(1) to get only the first return
      .flatMap(maxPublishers: .max(1)) {pair in
        decode(pair.data)
      }
      // IF you don’t use eraseToAnyPublisher() you’ll have to carry over the full type returned by flatMap: Publishers.FlatMap<AnyPublisher<_, WeatherError>, Publishers.MapError<URLSession.DataTaskPublisher, WeatherError>>.
      .eraseToAnyPublisher()
  }
}
