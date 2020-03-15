//
//  Formatters.swift
//  MVVM SwiftUI
//
//  Created by Will Xavier on 15/03/20.
//  Copyright © 2020 Willyelns Consulting and Development Services. All rights reserved.
//

import Foundation

let dayFormatter: DateFormatter = {
  let formatter = DateFormatter()
  formatter.dateFormat = "dd"
  return formatter
}()

let monthFormatter: DateFormatter = {
  let formatter = DateFormatter()
  formatter.dateFormat = "MMMM"
  return formatter
}()

let yearFormatter: DateFormatter = {
  let formatter = DateFormatter()
  formatter.dateFormat = "YYYY"
  return formatter
}()
