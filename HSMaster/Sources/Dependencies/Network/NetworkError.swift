//
//  NetworkError.swift
//  HSMaster
//
//  Created by Davide Ruisi on 06/11/21.
//

import Foundation

/// An `Error` thrown by the `NetworkManager`.
enum NetworkError: Error {
  /// A transport error received during the execution of a request.
  case transportError(_ error: Error)

  /// An error received during a request execution when the received response is not an HTTP one.
  case noHTTPResponse

  /// A server-side error received during the execution of a request.
  case serverError(_ statusCode: Int)

  /// The received response contains no data to be decoded.
  case noData

  /// Error occurred while serializing the received response.
  case responseSerializationError

  /// Error occurring while trying to get an access token if the instance of the Authenticator is missing.
  case missingAuthenticator

  /// Error occurring while trying to get an access token.
  case accessTokenRequestFailed
}
