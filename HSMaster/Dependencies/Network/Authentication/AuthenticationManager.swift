//
//  AuthenticationManager.swift
//  HSMaster
//
//  Created by Davide Ruisi on 21/11/21.
//

import Foundation
import Hydra

/// The class responsible of network requests' authentication.
final class AuthenticationManager {
  /// The last received access token. It can be `nil` if no tokens have been yet received.
  #warning("TODO: Use keychain")
  private var currentToken: Models.Authentication.AccessToken?

  /// The queue where `getToken()` promises are synchronized.
  /// This synchronization is needed to avoid un-needed token refresh.
  private let queue = DispatchQueue(label: "AuthenticationManager.\(UUID().uuidString)")

  /// The request executor that will execute authentication request to the authentication server.
  /// This is `weak` to avoid reference cycle.
  private weak var requestExecutor: RequestExecutor?

  init(requestExecutor: RequestExecutor?) {
    self.requestExecutor = requestExecutor
  }

  /// Gets a valid access token.
  /// If the last received token is still valid, the latter is returned.
  /// Otherwise a new access token will be fetched from the authentication server and then saved in place of the previous one.
  /// If the `forceRefresh` parameter is set to `true`, the last received token (if existing) is ignored,
  /// and a new token is fetched from the authentication server.
  /// - Parameter forceRefresh: Whether we want to get a new token from the authentication server in any case.
  /// - Returns: The `Promise` containing the access Token.
  func getToken(forceRefresh: Bool = false) -> Promise<Models.Authentication.AccessToken> {
    Promise(in: .custom(queue: queue)) { [weak self] resolve, reject, _ in
      guard let self = self else {
        AppLogger.critical("Missing instance of \(Self.self).")
        reject(NetworkError.missingAuthenticationManager)
        return
      }

      guard
        !forceRefresh,
        let currentToken = self.currentToken,
        currentToken.isValid
      else {
        self.refreshToken()
          .then(in: .background) { newToken in
            self.currentToken = newToken

            resolve(newToken)
          }
          .catch(in: .background) { error in
            reject(error)
          }

        return
      }

      resolve(currentToken)
    }
  }
}

// MARK: - Private Helpers

private extension AuthenticationManager {
  /// Executes the request to get a new access token from the authentication server.
  /// - Returns: The `Promise` containing the access Token.
  func refreshToken() -> Promise<Models.Authentication.AccessToken> {
    Promise { [weak self] resolve, reject, _ in
      guard
        let self = self,
        let requestExecutor = self.requestExecutor
      else {
        AppLogger.critical("Missing instance of \(Self.self) or \(AuthenticationManager.self).")
        reject(NetworkError.missingAuthenticationManager)
        return
      }

      requestExecutor.execute(Requests.Authentication.AccessToken.Get())
        .then(in: .background) { newToken in
          resolve(newToken)
        }
        .catch(in: .background) { _ in
          reject(NetworkError.accessTokenRequestFailed)
        }
    }
  }
}
