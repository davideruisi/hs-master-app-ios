//
//  URLRequestExecutor.swift
//  HSMaster
//
//  Created by Davide Ruisi on 06/11/21.
//

import Hydra
import Kingfisher

/// A class responsible of executing request.
class URLRequestExecutor: RequestExecutor, URLRequestBuilder, URLResponseSerializer {
  /// The `URLSession` in which requests are executed.
  /// Defaults to `URLSession.shared`.
  let session: URLSession

  /// The `Authenticator` responsible of generating access tokens for the requests.
  /// This is `weak` to avoid reference cycle.
  weak var authenticator: Authenticator?

  init(session: URLSession = URLSession.shared) {
    self.session = session
  }

  /// Execute a `Request`.
  /// - Parameter request: The request to be performed.
  /// - Returns: A `Promise` for the `ResponseModel` of the `Request`.
  func execute<R: Request>(_ request: R) -> Promise<R.ResponseModel> {
    Promise { [weak self] resolve, reject, _ in
      AppLogger.debug("Executing request: \(String(reflecting: R.self))")

      guard let self = self else {
        AppLogger.critical("Missing instance of \(URLRequestExecutor.self)")
        fatalError()
      }

      do {
        let urlRequest = try self.build(request)

        self.session.dataTask(with: urlRequest) { data, response, error in
          do {
            if let error = error {
              throw NetworkError.transportError(error)
            }

            guard let response = response as? HTTPURLResponse else {
              throw NetworkError.noHTTPResponse
            }

            guard 200...299 ~= response.statusCode else {
              // If the request requires `clientCredentials` authentication
              // and request fails with `401` status code (authentication error),
              // refresh the access token and retry the request.
              if case .clientCredentials = request.authenticationMethod, response.statusCode == 401 {
                AppLogger.error(
                  """
                  Error on request: \(String(reflecting: R.self))
                  Response: \(String(describing: response))
                  Error: \(NetworkError.serverError(response.statusCode))
                  Refreshing access token and retrying request.
                  """
                )

                guard let authenticator = self.authenticator else {
                  AppLogger.critical("Missing instance of \(Authenticator.self)")
                  throw NetworkError.missingAuthenticator
                }

                // Forces a token refresh.
                authenticator.getToken(forceRefresh: true)
                  .then(in: .background) { _  in
                    // Executes the same request again, this time with the new refreshed token.
                    self.execute(request)
                  }
                  .then(in: .background) { response in
                    // Finally resolve with the obtained response.
                    resolve(response)
                  }
                  .catch(in: .background) { error in
                    // Throws if any error occurs in the promises chain.
                    throw error
                  }

                return
              }

              throw NetworkError.serverError(response.statusCode)
            }

            guard let data = data else {
              throw NetworkError.noData
            }

            let serializedResponse: R.ResponseModel = try self.serialize(data)

            AppLogger.debug(
              """
              Success on request: \(String(reflecting: R.self))
              Response: \(response)
              Data: \(String(describing: data.prettyPrintedJSONString))
              Error: \(String(describing: error))
              """
            )

            resolve(serializedResponse)
          } catch {
            AppLogger.error(
              """
              Error on request: \(String(reflecting: R.self))
              Response: \(String(describing: response))
              Data: \(String(describing: data?.prettyPrintedJSONString))
              Error: \(error)
              """
            )
            reject(error)
          }
        }
        .resume()
      } catch {
        AppLogger.error(
          """
          Error on request: \(String(reflecting: R.self))
          Error: \(error)
          """
        )
        reject(error)
      }
    }
  }
}
