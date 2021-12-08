//
//  ContentfulModels.swift
//  HSMaster
//
//  Created by Davide Ruisi on 16/10/21.
//

import Contentful

// MARK: - Protocols

/// A protocol to which any Contentful model must adhere.
protocol ContentfulModel: EntryDecodable, FieldKeysQueryable, Resource {}

// MARK: - Contentful Models

extension Models {
  enum Contentful {}
}

extension Models.Contentful {
  /// The Contentful model for an Article shown in the Home tab of the app.
  final class Article: ContentfulModel {
    enum FieldKeys: String, CodingKey {
      case kicker
      case title
      case imageURL
      case date
      case sourceURL
    }

    // MARK: Contentful Properties

    static var contentTypeId: ContentTypeId = "article"
    let sys: Sys

    // MARK: Fields

    let kicker: String?
    let title: String?
    let imageURL: URL?
    let date: Date?
    let sourceURL: URL?

    init(from decoder: Decoder) throws {
      sys = try decoder.sys()

      let fields = try decoder.contentfulFieldsContainer(keyedBy: Self.FieldKeys.self)
      kicker = try? fields.decodeIfPresent(String.self, forKey: .kicker)
      title = try? fields.decodeIfPresent(String.self, forKey: .title)
      imageURL = try? fields.decodeIfPresent(URL.self, forKey: .imageURL)
      date = try? fields.decodeIfPresent(Date.self, forKey: .date)
      sourceURL = try? fields.decodeIfPresent(URL.self, forKey: .sourceURL)
    }
  }

  /// The Contentful model for a Deck shown in the Meta tab of the app.
  final class Deck: ContentfulModel {
    enum FieldKeys: String, CodingKey {
      case name
      case tier
      case position
      case code
    }

    // MARK: Contentful Properties

    static var contentTypeId: ContentTypeId = "deck"
    let sys: Sys

    // MARK: Fields

    let name: String?
    let tier: Int?
    let position: Int?
    let code: String?

    init(from decoder: Decoder) throws {
      sys = try decoder.sys()

      let fields = try decoder.contentfulFieldsContainer(keyedBy: Self.FieldKeys.self)
      name = try? fields.decodeIfPresent(String.self, forKey: .name)
      tier = try? fields.decodeIfPresent(Int.self, forKey: .tier)
      position = try? fields.decodeIfPresent(Int.self, forKey: .position)
      code = try? fields.decodeIfPresent(String.self, forKey: .code)
    }
  }
}

// MARK: - App Model Translations

extension Models.Contentful.Article: AppModellable {
  func toAppModel() -> Models.Article {
    Models.Article(
      imageURL: imageURL,
      kicker: kicker,
      title: title,
      subtitle: date?.iso8601String,
      sourceURL: sourceURL
    )
  }
}
