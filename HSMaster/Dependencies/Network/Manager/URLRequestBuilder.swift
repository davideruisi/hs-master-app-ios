//
//  URLRequestBuilder.swift
//  HSMaster
//
//  Created by Davide Ruisi on 06/11/21.
//

import Foundation

/// A protocol for building a `URLRequest` starting from a `Request`.
protocol URLRequestBuilder {
  /// Build a `URLRequest` from the `Request`.
  /// - Parameter request: The `Request` from which to build the `URLRequest`.
  /// - Returns: The builded `URLRequest`.
  func build<R: Request>(_ request: R) -> URLRequest
}

extension URLRequestBuilder {
  func build<R: Request>(_ request: R) -> URLRequest {
    request.asURLRequest()
  }
}

// MARK: - Helpers

fileprivate extension Request {
  /// Creates a `URLRequest` from `self`.
  /// - Returns: The corresponding `URLRequest`.
  func asURLRequest() -> URLRequest {
    let url = baseURL.appendingPathComponent(path)

    var urlRequest = URLRequest(url: url, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval)
    urlRequest.httpMethod = method.rawValue

    headers.forEach {
      urlRequest.addValue($0.value, forHTTPHeaderField: $0.key)
    }

    urlRequest.encode(queryParameters: queryParameters)

    return urlRequest
  }
}

fileprivate extension URLRequest {
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
