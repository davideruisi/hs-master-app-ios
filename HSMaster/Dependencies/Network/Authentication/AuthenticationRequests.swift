//
//  AuthenticationRequests.swift
//  HSMaster
//
//  Created by Davide Ruisi on 27/11/21.
//

import Foundation

extension Requests {
  enum Authentication {}
}

extension Requests.Authentication {
  enum AccessToken {}
}

extension Requests.Authentication.AccessToken {
  /// Get a new access token for API authentication.
  struct Get: Request {
    typealias ResponseModel = Models.Authentication.Response.AccessToken

    let method: HTTPMethod = .post

    let baseURL = BaseURL.authentication

    let path = "token"

    let headers = ["Authorization": "Basic \(Configuration.battleNetClientAuthenticationData)"]

    let bodyParameters = ["grant_type": "client_credentials"]
  }
}
