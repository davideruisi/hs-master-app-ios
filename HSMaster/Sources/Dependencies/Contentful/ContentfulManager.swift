//
//  ContentfulManager.swift
//  HSMaster
//
//  Created by Davide Ruisi on 16/10/21.
//

import Contentful
import Hydra

/// The `ContentfulManager` is responsible of fetching data from Contentful CMS.
final class ContentfulManager {
  /// The Contentful Client.
  private let client: Client

  init() {
    client = Client(
      spaceId: Configuration.contentfulSpaceID,
      accessToken: Configuration.contentfulAccessToken,
      contentTypeClasses: [Models.Contentful.Article.self, Models.Contentful.Deck.self]
    )
  }

  /// Fetch an array of contents of the specified type from Contentful CMS.
  /// - Parameters:
  ///   - type: The fetched elements' type.
  ///   - limit: The maximum number of items in the response. Useful for pagination. Defaults to 100.
  ///   - skip: The number of elements of the specified type we want to skip. Useful for pagination. Defaults to 0.
  ///   - orderField: The field used to order the result entries. If `nil` the result `entries` will be not ordered.
  ///   Defaults to `nil`.
  ///   - reverseOrder: Whether the result entries are ordered by the `orderField` in reverse.
  ///   This parameter is ignored if `orderField` is `nil`. Defaults to `false`.
  /// - Returns: The number of total entries that can be retrieved and
  /// an array containing a maximum of `limit` retrieved elements of the specified type, offset by `skip`.
  private func fetchArray<EntryType: ContentfulModel>(
    of type: EntryType.Type,
    limit: Int = 100,
    skip: Int = 0,
    orderBy orderField: EntryType.FieldKeys? = nil,
    reverseOrder: Bool = false
  ) -> Promise<(totalEntries: UInt, entries: [EntryType])> {
    Promise { [weak self] resolve, reject, _ in
      let query = QueryOn<EntryType>()
      query.parameters[QueryParameter.limit] = "\(limit)"
      query.parameters[QueryParameter.skip] = "\(skip)"
      if let orderField = orderField {
        query.order(by: try Ordered<EntryType>(field: orderField, inReverse: reverseOrder))
      }

      AppLogger.debug("Fetching array from Contentful of type: \(type).")
      self?.client.fetchArray(of: type, matching: query) { result in
        switch result {
        case .success(let response):
          AppLogger.debug("Received successful response from Contentful: \(response).")
          resolve((response.total, response.items))

        case .failure(let error):
          AppLogger.error("Error trying to fetch array from Contentful of type \(type): \(error)")
          reject(error)
        }
      }
    }
  }
}

// MARK: - App Requests

extension ContentfulManager {
  /// Get a list of Articles from Contentful CMS. The request can be paginated using `pageSize`and `offset` parameters.
  /// - Parameters:
  ///   - pageSize: The maximum number of `Article`s to be fetched.  Defaults to 100.
  ///   - offset: The offset from which to fetch entries. Useful for pagination. Defaults to 0.
  /// - Returns: A tuple containing the total number of entries in the Contentful CMS,
  /// and an array containing maximum `pageSize` `Articles`.
  func getArticles(pageSize: Int = 100, offset: Int = 0) -> Promise<(totalArticles: UInt, articles: [Models.Article])> {
    fetchArray(of: Models.Contentful.Article.self, limit: pageSize, skip: offset, orderBy: .date, reverseOrder: true)
      .then(in: .background) { ($0.totalEntries, $0.entries.toAppModel()) }
  }

  /// Get a list of Decks to be shown in the Meta tab from Contentful CMS.
  /// - Returns: An array containing `Deck`s.
  func getDecks() -> Promise<[Models.Deck]> {
    fetchArray(of: Models.Contentful.Deck.self, orderBy: .position)
      .then(in: .background) { $0.entries.toAppModel() }
  }
}
