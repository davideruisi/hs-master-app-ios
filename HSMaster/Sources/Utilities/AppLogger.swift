//
//  AppLogger.swift
//  HSMaster
//
//  Created by Davide Ruisi on 23/10/21.
//

import Foundation
import os

/// The app's logger.
enum AppLogger {
  /// The `Logger` used to log messages.
  private static let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "AppLogger", category: "AppLogger")

  /// Whether the `AppLogger` is in debug mode. We log only in debug mode.
  private static let isDebug: Bool = {
    #if DEBUG
    true
    #else
    false
    #endif
  }()

  /// Log a critical message.
  /// - Parameter message: The message to be logged.
  static func critical(_ message: @escaping @autoclosure () -> String) {
    if isDebug {
      logger.critical("\(message(), privacy: .auto)")
    }
  }

  /// Log an error message.
  /// - Parameter message: The message to be logged.
  static func error(_ message: @escaping @autoclosure () -> String) {
    if isDebug {
      logger.error("\(message(), privacy: .auto)")
    }
  }

  /// Log a debug message.
  /// - Parameter message: The message to be logged.
  static func debug(_ message: @escaping @autoclosure () -> String) {
    if isDebug {
      logger.debug("\(message(), privacy: .auto)")
    }
  }
}
