//
//  URLResponseSerializer.swift
//  HSMaster
//
//  Created by Davide Ruisi on 07/11/21.
//

import Foundation

/// Responsible of the Request's response serialization.
protocol URLResponseSerializer {
  /// Serializes the received response to obtain a decodable model.
  /// - Parameter data: The response data to be decoded.
  /// - Returns The desired response `Decodable` model.
  func serialize<R: Decodable>(_ data: Data) throws -> R
}

extension URLResponseSerializer {
  func serialize<R: Decodable>(_ data: Data) throws -> R {
    do {
      return try JSONDecoder().decode(R.self, from: data)
    } catch {
      throw NetworkError.responseSerializationError
    }
  }
}
