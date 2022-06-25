//
//  Request.swift
//  HSMaster
//
//  Created by Davide Ruisi on 06/11/21.
//

import Foundation

/// An HTTP Request with all the needed information.
protocol Request {
  /// The `Decodable` model of the request's response.
  associatedtype ResponseModel: Decodable

  /// The HTTP method of the API call.
  var method: HTTPMethod { get }

  /// The method used to authenticate the request.
  var authenticationMethod: AuthenticationMethod { get }

  /// The base URL of the API call.
  var baseURL: URL { get }

  /// The path of the API call.
  var path: String { get }

  /// The cache policy of the request.
  var cachePolicy: NSURLRequest.CachePolicy { get }

  /// The timeout interval of the request.
  var timeoutInterval: TimeInterval { get }

  /// The headers of the request.
  var headers: [String: String] { get }

  /// The query string parameters of the API request.
  var queryParameters: [String: String] { get }

  /// The body parameters of the API request.
  var bodyParameters: [String: String] { get }
}

// MARK: - Default Values

extension Request {
  var authenticationMethod: AuthenticationMethod {
    .none
  }

  var cachePolicy: NSURLRequest.CachePolicy {
    .reloadRevalidatingCacheData
  }

  var timeoutInterval: TimeInterval {
    30
  }

  var headers: [String: String] {
    [:]
  }

  var queryParameters: [String: String] {
    [:]
  }

  var bodyParameters: [String: String] {
    [:]
  }
}

// MARK: - Supporting Types

/// A method for an HTTP Request.
enum HTTPMethod: String {
  case get = "GET"
  case post = "POST"
}

/// The method to be used to authenticate the request.
enum AuthenticationMethod {
  case none
  case clientCredentials
}
