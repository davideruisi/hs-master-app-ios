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

  /// Whether the deck code has been copied in the pasteboard.
  private let deckCodeCopied: Bool

  /// The cards inside the deck, without repetitions and ordered by mana cost and name.
  private let orderedUniqueCards: [Models.Card]

  init?(state: AppState?, localState: DeckDetailLS) {
    self.deck = state?.meta.decks[safe: localState.deckIndex]
    self.deckCodeCopied = localState.deckCodeCopied

    /// Remove duplicates on cards and reorder by mana cost and name.
    let cards = Array(Set(deck?.detail?.cards ?? []))
    self.orderedUniqueCards = cards.sorted { $0.manaCost == $1.manaCost ? $0.name < $1.name : $0.manaCost < $1.manaCost }
  }
}

// MARK: Helpers

extension DeckDetailVM {
  /// The text inside the right button in the navigation bar.
  var navigationBarRightButtonItemTitle: String {
    deckCodeCopied ? HSMasterStrings.DeckDetail.DeckCode.copied : HSMasterStrings.DeckDetail.DeckCode.copy
  }

  /// Whether the activity indicator spinner should be visible.
  var shouldShowLoader: Bool {
    orderedUniqueCards.isEmpty
  }

  /// The number of cells in the `collectionView`.
  var numberOfCells: Int {
    orderedUniqueCards.count
  }

  /// The Card for the cell at `indexPath`.
  /// - Parameter indexPath: The IndexPath for which we want the card.
  /// - Returns: The `Card` shown in the cell at `indexPath`.
  func card(for indexPath: IndexPath) -> Models.Card? {
    orderedUniqueCards[safe: indexPath.item]
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
      quantity: quantity(for: card)
    )
  }

  /// The number of times the card appears in the deck.
  private func quantity(for card: Models.Card) -> Int {
    deck?.detail?.cards.filter{ $0 == card }.count ?? 0
  }
}

// MARK: - LocalState

/// The Local State for the DeckDetailView.
struct DeckDetailLS: LocalState {
  /// The index of the deck inside the meta state.
  let deckIndex: Int

  /// Whether the deck code has been copied in the pasteboard.
  let deckCodeCopied: Bool
}
