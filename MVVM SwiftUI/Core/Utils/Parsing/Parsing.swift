//
//  Parsing.swift
//  MVVM SwiftUI
//
//  Created by Will Xavier on 15/03/20.
//  Copyright © 2020 Willyelns Consulting and Development Services. All rights reserved.
//

import Foundation
import Combine

func decode<T: Decodable>(_ data: Data) -> AnyPublisher< T, ApplicationError> {
  let decoder = JSONDecoder()
  decoder.dateDecodingStrategy = .secondsSince1970
  
  return Just(data)
    .decode(type: T.self, decoder: decoder)
    .mapError{error in
        .parsing(description: error.localizedDescription)
    }
    .eraseToAnyPublisher()
}
