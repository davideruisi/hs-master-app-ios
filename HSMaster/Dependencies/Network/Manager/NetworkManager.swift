//
//  NetworkManager.swift
//  HSMaster
//
//  Created by Davide Ruisi on 03/11/21.
//

import Hydra

/// The `NetworkManager` contains all the login needed to execute all the network requests for the app.
final class NetworkManager {
  /// The object responsible for the request execution.
  let requestExecutor: RequestExecutor

  init(requestExecutor: RequestExecutor = URLRequestExecutor()) {
    self.requestExecutor = requestExecutor
  }

  /// Execute a `Request`.
  /// - Parameter request: The request to be performed.
  /// - Returns: A `Promise` for the `ResponseModel` of the `Request`.
  func execute<R: Request>(request: R) -> Promise<R.ResponseModel> {
    requestExecutor.execute(request)
  }
}

// MARK: - Requests

extension NetworkManager {
  /// Searches a list of cards.
  func getCardList(page: Int = 1, pageSize: Int = 500) -> Promise<(UInt, [Models.Card])> {
    requestExecutor.execute(Requests.CardList.Get(page: page, pageSize: pageSize))
      .then { cardListResponse in
        (cardListResponse.cardCount, cardListResponse.cards.toAppModel())
      }
  }
}
