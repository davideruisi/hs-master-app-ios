//
//  Models.swift
//  HSMaster
//
//  Created by Davide Ruisi on 09/10/21.
//

import Foundation

enum Models {}

// MARK: - Article

/// Contains all the models used by the app.
extension Models {
  /// The Model of and Article that can be shown in the Home tab.
  struct Article: Equatable {
    let imageURL: URL?
    let kicker: String?
    let title: String?
    let subtitle: String?
    let sourceURL: URL?
  }
}

// MARK: - Card

extension Models {
  /// The Model of a card.
  struct Card: Equatable {
    /// The URL of the card image.
    let imageURL: URL?
  }
}

// MARK: - Metadata

extension Models {
  /// The Metadata of Hearthstone game.
  struct Metadata {
    /// A playable class in Hearthstone.
    struct Class {
      let id: Int
      let name: String
    }

    /// A card keyword.
    struct Keyword {
      let id: Int
      let name: String
      let description: String
    }

    /// A set of cards in Hearthstone.
    struct Set {
      let id: Int
      let name: String
    }

    /// The list of classes in Hearthstone.
    let classes: [Class]

    /// The list of keyword in Hearthstone.
    let keywords: [Keyword]

    /// The list of Hearthstone sets.
    let sets: [Set]
  }
}

extension Models.Metadata {
  init() {
    classes = []
    keywords = []
    sets = []
  }
}
