//
//  Configuration.swift
//  HSMaster
//
//  Created by Davide Ruisi on 22/10/21.
//

import Foundation
import Logging

/// Contains values taken by app's configuration files.
enum Configuration {
  /// The Contentful's space identifier. Used in the `ContentfulManager`'s `Client` initialization.
  static var contentfulSpaceID: String {
    value(for: .contentfulSpaceID)
  }

  /// The Contentful's access token. Used in the `ContentfulManager`'s `Client` initialization.
  static var contentfulAccessToken: String {
    value(for: .contentfulAccessToken)
  }
}

private extension Configuration {
  /// A key contained in the app's configuration files.
  enum Key: String {
    case contentfulSpaceID = "CONTENTFUL_SPACE_ID"
    case contentfulAccessToken = "CONTENTFUL_ACCESS_TOKEN"
  }

  /// Extract the specified key's value from the app info dictionary.
  /// - Parameter key: The key of the value we want.
  /// - Returns: The value in the info dictionary for the specified key.
  static func value(for key: Key) -> String {
    guard let value = Bundle.main.object(forInfoDictionaryKey: key.rawValue) as? String else {
      AppLogger.error("Unable to find value for key: '\(key)'.")
      return ""
    }

    return value
  }
}
