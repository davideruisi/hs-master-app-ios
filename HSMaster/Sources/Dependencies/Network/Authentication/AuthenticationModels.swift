//
//  AuthenticationModels.swift
//  HSMaster
//
//  Created by Davide Ruisi on 27/11/21.
//

import Foundation

extension Models {
  enum Authentication {}
}

extension Models.Authentication {
  enum Response {}
}

// MARK: - App Model

extension Models.Authentication {
  /// Model of the battle.net `AccessToken`.
  /// `Codable` conformance is needed to save the token in the keychain.
  struct AccessToken: Codable {

    // MARK: Stored Properties

    /// The effective `String` containing the access token.
    let value: String

    /// The token expiring date.
    let expiringDate: Date

    // MARK: Computed Properties

    /// Whether the token is still valid.
    var isValid: Bool {
      Date() < expiringDate
    }
  }
}

// MARK: - Response Model

extension Models.Authentication.Response {
  /// Model of the battle.net `AccessToken` as received in response of the `Requests.Authentication.AccessToken.Get`.
  struct AccessToken: Decodable {
    enum CodingKeys: String, CodingKey {
      case accessToken = "access_token"
      case lifetime = "expires_in"
    }

    /// The effective `String` containing the access token.
    let accessToken: String

    /// The token lifetime.
    let lifetime: TimeInterval
  }
}

extension Models.Authentication.Response.AccessToken: AppModellable {
  func toAppModel() -> Models.Authentication.AccessToken {
    Models.Authentication.AccessToken(value: accessToken, expiringDate: Date().addingTimeInterval(lifetime))
  }
}
