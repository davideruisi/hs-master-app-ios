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

  /// The `Authenticator` responsible of generating access tokens for the requests.
  let authenticator: Authenticator

  init(requestExecutor: RequestExecutor = URLRequestExecutor(), authenticator: Authenticator = AuthenticationManager()) {
    self.requestExecutor = requestExecutor
    self.authenticator = authenticator
    requestExecutor.authenticator = authenticator
    authenticator.requestExecutor = requestExecutor
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
  /// - Parameters:
  ///   - filter: The filter to be applied on the search request.
  ///   - page: The requested page of the list.
  ///   - pageSize: The dimension of each page in the returned response. Defaults to `500`.
  /// - Returns: The promise containing a tuple with the total number of cards and the page of the cards list.
  func getCardList(filter: Models.CardSearch.Filter, page: Int, pageSize: Int = 500) -> Promise<(UInt, [Models.Card])> {
    requestExecutor.execute(
      Requests.CardList.Get(
        filter: filter,
        page: page,
        pageSize: pageSize
      )
    )
      .then(in: .background) { cardListResponse in
        (cardListResponse.cardCount, cardListResponse.cards.toAppModel())
      }
  }

  /// Gets the `Detail` of the `Deck` with the specified `code`.
  /// - Parameter code: The Deck code.
  /// - Returns: A promise containing the `Deck.Detail`.
  func getDeckDetail(with code: String) -> Promise<Models.Deck.Detail> {
    requestExecutor.execute(Requests.DeckDetail.Get(code: code))
      .then(in: .background) { deckDetailResponse in
        deckDetailResponse.toAppModel()
      }
  }

  /// Get the Hearthstone game metadata.
  /// - Returns: The promise containing the struct with all the `Metadata`.
  func getMetadata() -> Promise<Models.Metadata> {
    requestExecutor.execute(Requests.Metadata.Get())
      .then(in: .background) { response in
        response.toAppModel()
      }
  }
}
