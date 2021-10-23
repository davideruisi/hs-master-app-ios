//
//  AppLogger.swift
//  HSMaster
//
//  Created by Davide Ruisi on 23/10/21.
//

import Logging

/// The app's logger.
enum AppLogger {
  /// The `Logger` used to log messages.
  private static var logger = Logger(label: "com.davideruisi.HSMaster")

  /// Whether the `AppLogger` is in debug mode. We log only in debug mode.
  private static var isDebug: Bool {
    #if DEBUG
    true
    #else
    false
    #endif
  }

  /// Log an error message.
  /// - Parameter message: The message to be logged.
  static func error(_ message: @autoclosure () -> Logger.Message) {
    if isDebug {
      logger.error(message())
    }
  }
}
