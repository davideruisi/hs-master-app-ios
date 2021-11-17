//
//  Requests.swift
//  HSMaster
//
//  Created by Davide Ruisi on 14/11/21.
//

import Foundation

enum Requests {}

extension Requests {
  enum CardList {}
}

extension Requests.CardList {
  /// Get the list of cards. The response is paginated.
  struct Get: Request {
    typealias ResponseModel = Models.Response.CardList

    let method: HTTPMethod = .get

    let baseURL = BaseURL.hearthstone

    let path = "cards"

    let cachePolicy: NSURLRequest.CachePolicy = .useProtocolCachePolicy

    let timeoutInterval: TimeInterval = 30

    let headers: [String: String] = ["Authorization": "Bearer USanWzcuQtznG31WTwYxWOn5P7D3VPYXJQ"]

    // The requested page of the list.
    let page: Int

    // The size of each page in the list.
    let pageSize: Int

    var queryParameters: [String: String] {
      [
        "locale": "en_US",
        "sort": "groupByClass,manaCost,name",
        "set": "standard",
        "textFilter": "",
        "page": "\(page)",
        "pageSize": "\(pageSize)"
      ]
    }
  }
}
