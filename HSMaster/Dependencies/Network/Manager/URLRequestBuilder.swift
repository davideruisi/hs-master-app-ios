//
//  URLRequestBuilder.swift
//  HSMaster
//
//  Created by Davide Ruisi on 06/11/21.
//

import Foundation
import Hydra

/// A protocol for building a `URLRequest` starting from a `Request`.
protocol URLRequestBuilder {
  /// The `AuthenticationManager` where we can get the access token if needed.
  var authenticationManager: AuthenticationManager { get }

  /// Build a `URLRequest` from the `Request`.
  /// - Parameter request: The `Request` from which to build the `URLRequest`.
  /// - Returns: The builded `URLRequest`.
  func build<R: Request>(_ request: R) throws -> URLRequest
}

extension URLRequestBuilder {
  func build<R: Request>(_ request: R) throws -> URLRequest {
    let url = request.baseURL.appendingPathComponent(request.path)

    var urlRequest = URLRequest(url: url, cachePolicy: request.cachePolicy, timeoutInterval: request.timeoutInterval)
    urlRequest.httpMethod = request.method.rawValue

    request.headers.forEach {
      urlRequest.addValue($0.value, forHTTPHeaderField: $0.key)
    }

    if case .clientCredentials = request.authenticationMethod {
      let accessToken = try Hydra.await(authenticationManager.getToken())
      urlRequest.setValue("Bearer \(accessToken.value)", forHTTPHeaderField: "Authorization")
    }

    urlRequest.encode(queryParameters: request.queryParameters)
    urlRequest.encode(bodyParameters: request.bodyParameters)

    return urlRequest
  }
}

// MARK: - Helpers

fileprivate extension URLRequest {
  /// Adds `bodyParameters` to `self`.
  /// - Parameter bodyParameters: A `[String: String]` dictionary containing all the body parameters.
  mutating func encode(bodyParameters: [String: String]) {
    let body = bodyParameters.map { key, value in
      let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .afURLQueryAllowed) ?? ""
      let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .afURLQueryAllowed) ?? ""
      return "\(escapedKey)=\(escapedValue)"
    }
      .joined(separator: "&")
      .data(using: .utf8)

    self.httpBody = body
  }

  /// Adds `queryParameters` to `self`.
  /// - Parameter queryParameters: A `[String: String]` dictionary containing all the query parameters.
  mutating func encode(queryParameters: [String: String]) {
    guard
      let url = self.url,
      var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false),
      !queryParameters.isEmpty
    else {
      return
    }

    let query = (urlComponents.percentEncodedQuery.map { $0 + "&" } ?? "") + query(from: queryParameters)
    urlComponents.percentEncodedQuery = query

    self.url = urlComponents.url
  }

  /// Creates a URL query string from `queryParameters`.
  /// - Parameter queryParameters: A `[String: String]` dictionary containing all the query parameters.
  /// - Returns: A `String` containing URL-encoded parameters.
  func query(from queryParameters: [String: String]) -> String {
    queryParameters.map { "\(escape($0.key))=\(escape($0.value))" }.joined(separator: "&")
  }

  /// Escapes all not query allowed characters in the input string.
  /// - Parameter string: The `String` to be escaped.
  /// - Returns: The escaped string.
  func escape(_ string: String) -> String {
    string.addingPercentEncoding(withAllowedCharacters: .afURLQueryAllowed) ?? string
  }
}

fileprivate extension CharacterSet {
  /// Creates a CharacterSet from RFC 3986 allowed characters.
  ///
  /// RFC 3986 states that the following characters are "reserved" characters.
  ///
  /// - General Delimiters: ":", "#", "[", "]", "@", "?", "/"
  /// - Sub-Delimiters: "!", "$", "&", "'", "(", ")", "*", "+", ",", ";", "="
  ///
  /// In RFC 3986 - Section 3.4, it states that the "?" and "/" characters should not be escaped to allow
  /// query strings to include a URL. Therefore, all "reserved" characters with the exception of "?" and "/"
  /// should be percent-escaped in the query string.
  static let afURLQueryAllowed: CharacterSet = {
    let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
    let subDelimitersToEncode = "!$&'()*+,;="
    let encodableDelimiters = CharacterSet(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")

    return CharacterSet.urlQueryAllowed.subtracting(encodableDelimiters)
  }()
}
