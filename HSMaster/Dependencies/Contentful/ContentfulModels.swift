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

/// A ContentfulModel that adhere to this protocol can be translated to the corresponding AppModel.
protocol AppModellable: ContentfulModel {
  associatedtype AppModel

  /// Obtain the corresponding `AppModel`.
  func toAppModel() -> AppModel
}

// MARK: - Contentful Models

extension Model {
  enum Contentful {}
}

extension Model.Contentful {
  /// The Contentful model for an Article shown in the Home tab of the app.
  final class Article: ContentfulModel {
    enum FieldKeys: String, CodingKey {
      case kicker
      case title
      case body
      case imageURL
      case date
    }

    // MARK: Contentful Properties

    static var contentTypeId: ContentTypeId = "article"
    let sys: Sys

    // MARK: Fields

    let kicker: String?
    let title: String?
    let body: String?
    let imageURL: String?
    let date: Date?

    init(from decoder: Decoder) throws {
      sys = try decoder.sys()

      let fields = try decoder.contentfulFieldsContainer(keyedBy: Self.FieldKeys.self)
      kicker = try? fields.decodeIfPresent(String.self, forKey: .kicker)
      title = try? fields.decodeIfPresent(String.self, forKey: .title)
      body = try? fields.decodeIfPresent(String.self, forKey: .body)
      imageURL = try? fields.decodeIfPresent(String.self, forKey: .imageURL)
      date = try? fields.decodeIfPresent(Date.self, forKey: .date)
    }
  }
}

// MARK: - App Model Translations

extension Model.Contentful.Article: AppModellable {
  func toAppModel() -> Model.Article {
    Model.Article(
      imageURL: URL(string: imageURL ?? ""),
      kicker: kicker,
      title: title,
      body: body
    )
  }
}

extension Array where Element: Model.Contentful.Article {
  func toAppModel() -> [Model.Article] {
    map { $0.toAppModel() }
  }
}
