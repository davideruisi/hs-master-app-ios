//
//  DeckDetailVM.swift
//  HSMaster
//
//  Created by Davide Ruisi on 13/12/21.
//

import Foundation
import Tempura

// MARK: - ViewModel

/// The ViewModel of the DeckDetailView.
struct DeckDetailVM: ViewModelWithLocalState, Equatable {
  /// The deck shown in  the view.
  let deck: Models.Deck?

  init?(state: AppState?, localState: DeckDetailLS) {
    deck = state?.meta.decks[safe: localState.deckIndex]
  }
}

// MARK: Helpers

extension DeckDetailVM {
  /// The number of cells in the `collectionView`.
  var numberOfCells: Int {
    deck?.detail?.cards.count ?? 0
  }

  /// The Card for the cell at `indexPath`.
  /// - Parameter indexPath: The IndexPath for which we want the card.
  /// - Returns: The `Card` shown in the cell at `indexPath`.
  func card(for indexPath: IndexPath) -> Models.Card? {
    deck?.detail?.cards[safe: indexPath.item]
  }

  /// Creates the `ViewModel` for the `DeckCardCell` at the specified `indexPath`.
  /// - Parameter indexPath: The `IndexPath` of the `DeckCardCell` for which we want the `ViewModel`
  /// - Returns: The `DeckCardCellVM` for the specified `indexPath`.
  func deckCardCellVM(at indexPath: IndexPath) -> DeckCardCellVM? {
    guard let card = card(for: indexPath) else {
      AppLogger.critical("Missing instance of \(Models.Card.self).")
      return nil
    }

    return DeckCardCellVM(
      croppedCardImageURL: card.croppedImageURL,
      manaCost: card.manaCost,
      name: card.name,
      quantity: 1
    )
  }
}

// MARK: - LocalState

/// The Local State for the DeckDetailView.
struct DeckDetailLS: LocalState {
  /// The index of the deck inside the meta state.
  let deckIndex: Int
}
