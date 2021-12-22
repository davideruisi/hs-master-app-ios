//
//  Models.swift
//  HSMaster
//
//  Created by Davide Ruisi on 09/10/21.
//

import UIKit

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
  struct Card: Equatable, Hashable {
    /// The artist of the card image.
    let artistName: String?

    /// The classes ids of the card. A card can have multiple classes.
    let classIds: [Int]

    /// The cropped image of the card, to be used in deck's detail.
    let croppedImageURL: URL?

    /// The flavor text of the card.
    let flavorText: String?

    /// The URL of the card image.
    let imageURL: URL?

    /// List of keyword ids used by this card.
    let keywordIds: [Int]

    /// The cost in mana of the card.
    let manaCost: Int

    /// The name of the card.
    let name: String

    /// The id of the set of the card.
    let setId: Int
  }
}

// MARK: - Deck

extension Models {
  /// The model of a Deck to be shown in the Meta tab.
  struct Deck: Equatable {
    /// The detail of the deck.
    struct Detail: Equatable {
      let classId: Int
      let cards: [Models.Card]
    }

    /// The name of the deck.
    let name: String?

    /// The tier of the deck in the meta.
    let tier: Int

    /// The position of the deck in the meta.
    let position: Int

    /// The code string of the deck to fetch additional details.
    let code: String

    /// The detail of the deck. It can be `nil` if the detail has not been already be fetched from back-end.
    let detail: Detail?
  }
}

// MARK: - Metadata

extension Models {
  /// The Metadata of Hearthstone game.
  struct Metadata: Equatable {
    /// A playable class in Hearthstone.
    struct Class: Equatable {
      let id: Int
      let name: String

      var icon: UIImage? {
        switch self.id {
        case 14:
          // Demon Hunter.
          return Images.ClassIcons.demonHunterIcon.image

        case 2:
          // Druid.
          return Images.ClassIcons.druidIcon.image

        case 3:
          // Hunter.
          return Images.ClassIcons.hunterIcon.image

        case 4:
          // Mage.
          return Images.ClassIcons.mageIcon.image

        case 5:
          // Paladin.
          return Images.ClassIcons.paladinIcon.image

        case 6:
          // Priest.
          return Images.ClassIcons.priestIcon.image

        case 7:
          // Rogue.
          return Images.ClassIcons.rogueIcon.image

        case 8:
          // Shaman.
          return Images.ClassIcons.shamanIcon.image

        case 9:
          // Warlock.
          return Images.ClassIcons.warlockIcon.image

        case 10:
          // Warrior.
          return Images.ClassIcons.warriorIcon.image

        case 12:
          // Neutral.
          return nil

        default:
          return nil
        }
      }
    }

    /// A card keyword.
    struct Keyword: Equatable {
      let id: Int
      let name: String
      let description: String
    }

    /// A set of cards in Hearthstone.
    struct Set: Equatable {
      let id: Int
      let name: String
    }

    // MARK: Properties

    /// The list of classes in Hearthstone.
    let classes: [Class]

    /// The list of keyword in Hearthstone.
    let keywords: [Keyword]

    /// The list of Hearthstone sets.
    let sets: [Set]

    // MARK: Helpers

    func getClass(with id: Int?) -> Class? {
      classes.first { $0.id == id }
    }

    func getKeyword(with id: Int) -> Keyword? {
      keywords.first { $0.id == id }
    }

    func getSet(with id: Int) -> Set? {
      sets.first { $0.id == id }
    }
  }
}

extension Models.Metadata {
  init() {
    classes = []
    keywords = []
    sets = []
  }
}
