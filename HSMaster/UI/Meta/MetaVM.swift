//
//  MetaVM.swift
//  HSMaster
//
//  Created by Davide Ruisi on 07/12/21.
//

import Foundation
import Tempura

/// The ViewModel of the `MetaView`.
struct MetaVM: ViewModelWithState, Equatable {
  let decks: [Models.Deck]
  let metadata: Models.Metadata

  init?(state: AppState) {
    decks = state.meta.decks
    metadata = state.metadata
  }
}

// MARK: - Helpers

extension MetaVM {
  /// The number of cells in the `collectionView`.
  var numberOfCells: Int {
    decks.count
  }

  /// Returns the deck at the specified IndexPath.
  /// - Parameter indexPath: The IndexPath for which we want the deck.
  /// - Returns The `Deck` at `indexPath`.
  func deck(for indexPath: IndexPath) -> Models.Deck? {
    decks[safe: indexPath.item]
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
