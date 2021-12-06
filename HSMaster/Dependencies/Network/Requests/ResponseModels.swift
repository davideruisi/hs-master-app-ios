//
//  ResponseModels.swift
//  HSMaster
//
//  Created by Davide Ruisi on 13/11/21.
//

import Foundation

extension Models {
  enum Response {}
}

// MARK: - Metadata

extension Models.Response {
  /// Model for the response of the Metadata request.
  struct Metadata: Decodable {
    let sets: [Set]
    let setGroups: [SetGroup]
    let types: [CardType]
    let rarities: [Rarity]
    let classes: [Class]
    let minionTypes: [MinionType]
    let spellSchools: [SpellSchool]
    let keywords: [Keyword]
    let filterableFields: [String]
    let numericFields: [String]
  }
}

extension Models.Response.Metadata {
  struct CardType: Decodable {
    let slug: String
    let id: Int
    let name: String
  }

  struct Class: Decodable {
    let slug: String
    let id: Int
    let name: String
    let cardId: Int?
    let heroPowerCardId: Int?
    let alternateHeroCardIds: [Int]?
  }

  struct Keyword: Decodable {
    let id: Int
    let slug: String
    let name: String
    let refText: String
    let text: String
    let gameModes: [Int]
  }

  struct MinionType: Decodable {
    let slug: String
    let id: Int
    let name: String
  }

  struct Rarity: Decodable {
    let slug: String
    let id: Int
    let craftingCost: [Int?]
    let dustValue: [Int?]
    let name: String
  }

  struct SetGroup: Decodable {
    let slug: String
    let year: Int?
    let svg: String?
    let cardSets: [String]
    let name: String
    let standard: Bool?
    let icon: String?
    let yearRange: String?
  }

  struct Set: Decodable {
    enum SetType: String, Codable {
      case adventure = "adventure"
      case base = "base"
      case empty = ""
      case expansion = "expansion"
    }

    let id: Int
    let name: String
    let slug: String
    let type: SetType
    let collectibleCount: Int
    let collectibleRevealedCount: Int
    let nonCollectibleCount: Int
    let nonCollectibleRevealedCount: Int
    let aliasSetIds: [Int]?
  }

  struct SpellSchool: Decodable {
    let slug: String
    let id: Int
    let name: String
  }
}

// MARK: - Card

extension Models.Response {
  /// The model for the response of the CardList request.
  struct CardList: Decodable {
    /// Received cards.
    let cards: [Card]

    /// Total number of cards that can be fetched for this request.
    let cardCount: UInt

    /// Total number of pages for this request.
    let pageCount: Int

    /// The obtained page number.
    let page: Int
  }

  /// The model of a Card received form API.
  struct Card: Decodable {
    let id: Int
    let slug: String
    let classId: Int
    let multiClassIds: [Int]
    let spellSchoolId: Int?
    let cardTypeId: Int
    let cardSetId: Int
    let rarityId: Int
    let artistName: String?
    let manaCost: Int
    let name: String
    let text: String
    let image: URL
    let flavorText: String
    let cropImage: String
    let keywordIds: [Int]?
    let health, attack, durability: Int?
    let childIds: [Int]?
    let minionTypeId: Int?
    let copyOfCardId: Int?
  }
}

// MARK: - App Model Translations

extension Models.Response.Card: AppModellable {
  func toAppModel() -> Models.Card {
    Models.Card(
      artistName: artistName,
      classIds: multiClassIds.isEmpty ? [classId] : multiClassIds,
      flavorText: flavorText,
      imageURL: image,
      keywordIds: keywordIds ?? [],
      name: name,
      setId: cardSetId
    )
  }
}

extension Models.Response.Metadata.Class: AppModellable {
  func toAppModel() -> Models.Metadata.Class {
    Models.Metadata.Class(id: id, name: name)
  }
}

extension Models.Response.Metadata.Keyword: AppModellable {
  func toAppModel() -> Models.Metadata.Keyword {
    Models.Metadata.Keyword(id: id, name: name, description: text)
  }
}

extension Models.Response.Metadata.Set: AppModellable {
  func toAppModel() -> Models.Metadata.Set {
    Models.Metadata.Set(id: id, name: name)
  }
}

extension Models.Response.Metadata: AppModellable {
  func toAppModel() -> Models.Metadata {
    Models.Metadata(classes: classes.toAppModel(), keywords: keywords.toAppModel(), sets: sets.toAppModel())
  }
}
