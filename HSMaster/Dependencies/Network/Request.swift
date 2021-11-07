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
}

/// A method for an HTTP Request.
enum HTTPMethod: String {
  case get = "GET"
}
