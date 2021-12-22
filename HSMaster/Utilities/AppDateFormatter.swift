//
//  AppDateFormatter.swift
//  HSMaster
//
//  Created by Davide Ruisi on 22/12/21.
//

import Foundation

/// Contains the date formatters used inside the app.
private enum AppDateFormatter {
  /// The default DateFormatter used inside the App.
  static let defaultFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .long
    dateFormatter.timeStyle = .none

    return dateFormatter
  }()
}

extension Date {
  /// A `String`containing the pretty formatted date using the `AppDateFormatter.defaultFormatter`.
  var appFormattedString: String {
    AppDateFormatter.defaultFormatter.string(from: self)
  }
}
