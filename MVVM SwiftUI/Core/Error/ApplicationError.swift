//
//  ParsingError.swift
//  MVVM SwiftUI
//
//  Created by Will Xavier on 15/03/20.
//  Copyright © 2020 Willyelns Consulting and Development Services. All rights reserved.
//

import Foundation

enum ApplicationError: Error, Equatable {
  case parsing(description: String)
  case network(description: String)
    // Add Here more errors and attributes
}
