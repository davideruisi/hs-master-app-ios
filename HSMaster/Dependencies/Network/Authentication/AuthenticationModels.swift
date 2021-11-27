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
  /// Model of the battle.net `AccessToken`.
  struct AccessToken: Decodable {

    // MARK: CodingKeys

    enum CodingKeys: String, CodingKey {
      case accessToken = "access_token"
      case lifetime = "expires_in"
    }

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

    // MARK: Init

    init(from decoder: Decoder) throws {
      let values = try decoder.container(keyedBy: CodingKeys.self)

      value = try values.decode(String.self, forKey: .accessToken)

      let lifetime = try values.decode(TimeInterval.self, forKey: .lifetime)
      expiringDate = Date().addingTimeInterval(lifetime)
    }
  }
}
