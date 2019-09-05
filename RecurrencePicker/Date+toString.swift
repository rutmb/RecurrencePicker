//
//  Date+toString.swift
//  RecurrencePicker
//
//  Created by Igor Rudenko on 05/09/2019.
//  Copyright © 2019 Teambition. All rights reserved.
//

import Foundation

extension Date {
  func toString(format: String = "E, d MMM yyyy") -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = format
    return formatter.string(from: self)
  }
}
