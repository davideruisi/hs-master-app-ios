//
//  URLRequestExecutor.swift
//  HSMaster
//
//  Created by Davide Ruisi on 06/11/21.
//

import Hydra

/// A class responsible of executing request.
class URLRequestExecutor: RequestExecutor, URLRequestBuilder, URLResponseSerializer {
  /// The `URLSession` in which requests are executed.
  /// Defaults to `URLSession.shared`.
  let session: URLSession

  init(session: URLSession = URLSession.shared) {
    self.session = session
  }

  /// Execute a `Request`.
  /// - Parameter request: The request to be performed.
  /// - Returns: A `Promise` for the `ResponseModel` of the `Request`.
  func execute<R: Request>(_ request: R) -> Promise<R.ResponseModel> {
    Promise { [weak self] resolve, reject, _ in
      guard let self = self else {
        AppLogger.critical("Missing instance of \(URLRequestExecutor.self)")
        fatalError()
      }

      let urlRequest = self.build(request)

      self.session.dataTask(with: urlRequest) { data, response, error in
        do {
          if let error = error {
            throw NetworkError.transportError(error)
          }

          guard let response = response as? HTTPURLResponse else {
            throw NetworkError.noHTTPResponse
          }

          guard 200...299 ~= response.statusCode else {
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
    }
  }
}
