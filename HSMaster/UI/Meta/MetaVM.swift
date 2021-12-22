//
//  MetaVM.swift
//  HSMaster
//
//  Created by Davide Ruisi on 07/12/21.
//

import Foundation
import Tempura

/// The ViewModel of the `MetaView`.
struct MetaVM: ViewModelWithState {
  /// The game metadata.
  let metadata: Models.Metadata
  
  /// The meta decks grouped by `tier` and ordered by `position`.
  let tiers: [(key: Int, value: [Models.Deck])]

  init?(state: AppState) {
    metadata = state.metadata

    var groupedDecksByTier = Dictionary(grouping: state.meta.decks, by: { $0.tier })
    groupedDecksByTier.forEach { tier, decks in
      groupedDecksByTier[tier] = decks.sorted(by: { $0.position < $1.position })
    }
    tiers = groupedDecksByTier.sorted(by: { $0.key < $1.key })
  }
}

// MARK: - Equatable

extension MetaVM: Equatable {
  static func == (lhs: MetaVM, rhs: MetaVM) -> Bool {
    guard
      lhs.metadata == rhs.metadata,
      lhs.tiers.count == rhs.tiers.count
    else {
      return false
    }

    for index in 0 ..< lhs.tiers.count {
      guard lhs.tiers[index] == rhs.tiers[index] else {
        return false
      }
    }

    return true
  }
}

// MARK: - Helpers

extension MetaVM {
  /// The number of sections in the `collectionView`.
  var numberOfSections: Int {
    tiers.count
  }

  /// The number of cells in the specified section of the `collectionView`.
  func numberOfCells(in section: Int) -> Int {
    tiers[section].value.count
  }

  /// The view model for the header in the specified section of the `collectionView`.
  func tierSectionHeaderVM(for section: Int) -> TierSectionHeaderVM {
    guard let tier = tiers[safe: section]?.key else {
      return TierSectionHeaderVM(title: Localization.MetaTab.tierTitle("?"))
    }

    return TierSectionHeaderVM(title: Localization.MetaTab.tierTitle(tier))
  }

  /// Returns the deck at the specified IndexPath.
  /// - Parameter indexPath: The IndexPath for which we want the deck.
  /// - Returns The `Deck` at `indexPath`.
  func deck(for indexPath: IndexPath) -> Models.Deck? {
    tiers[safe: indexPath.section]?.value[safe: indexPath.item]
  }

  /// Creates the `ViewModel` for the `DeckCell` at the specified `indexPath`.
  /// - Parameter indexPath: The `IndexPath` of the `DeckCell` for which we want the `ViewModel`
  /// - Returns: The `DeckCellVM` for the specified `indexPath`.
  func deckCellVM(at indexPath: IndexPath) -> DeckCellVM {
    let deck = deck(for: indexPath)

    return DeckCellVM(
      classImage: metadata.getClass(with: deck?.detail?.classId)?.icon,
      name: deck?.name
    )
  }
}
