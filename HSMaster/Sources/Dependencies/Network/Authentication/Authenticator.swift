//
//  Authenticator.swift
//  HSMaster
//
//  Created by Davide Ruisi on 23/12/21.
//

import Hydra

/// A class conforming to this protocol is responsible of authenticating network requests.
protocol Authenticator: AnyObject {
  /// The request executor that will execute authentication request to the authentication server.
  var requestExecutor: RequestExecutor? { get set }

  /// Gets a valid access token.
  /// If the last received token is still valid, the latter is returned.
  /// Otherwise a new access token will be fetched from the authentication server and then saved in place of the previous one.
  /// If the `forceRefresh` parameter is set to `true`, the last received token (if existing) is ignored,
  /// and a new token is fetched from the authentication server.
  /// - Parameter forceRefresh: Whether we want to get a new token from the authentication server in any case.
  /// - Returns: The `Promise` containing the access Token.
  func getToken(forceRefresh: Bool) -> Promise<Models.Authentication.AccessToken>
}
