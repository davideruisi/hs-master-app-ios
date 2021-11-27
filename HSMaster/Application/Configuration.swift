//
//  Configuration.swift
//  HSMaster
//
//  Created by Davide Ruisi on 22/10/21.
//

import Foundation

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

  /// The battle.net client identifier. Used for credentials to get access token from the `AuthenticationManager`.
  static var battleNetClientID: String {
    value(for: .battleNetClientID)
  }

  /// The battle.net client secret. Used for credentials to get access token from the `AuthenticationManager`.
  static var battleNetClientSecret: String {
    value(for: .battleNetClientSecret)
  }

  /// The battle.net client authentication data. Used for basic authentication header in `Requests.AccessToken.Get` request.
  static var battleNetClientAuthenticationData: String {
    let user = Self.battleNetClientID
    let password = Self.battleNetClientSecret

    // swiftlint:disable:next force_unwrapping
    return "\(user):\(password)".data(using: .utf8)!.base64EncodedString()
  }
}

private extension Configuration {
  /// A key contained in the app's configuration files.
  enum Key: String {
    case contentfulSpaceID = "CONTENTFUL_SPACE_ID"
    case contentfulAccessToken = "CONTENTFUL_ACCESS_TOKEN"

    case battleNetClientID = "BATTLE_NET_CLIENT_ID"
    case battleNetClientSecret = "BATTLE_NET_CLIENT_SECRET"
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
