//
//  CardSearchVM.swift
//  HSMaster
//
//  Created by Davide Ruisi on 09/11/21.
//

import Foundation
import Tempura

/// The ViewModel of the `CardSearchView`.
struct CardSearchVM: ViewModelWithState {
  /// The sections inside the `collectionView`.
  enum Section: Int, CaseIterable {
    /// The list of cards.
    case cards = 0

    /// The section containing a loading cell.
    case loading = 1
  }

  /// The list of cards to be shown  in the `collectionView`.
  let cards: [Models.Card]

  /// The total number of cards available on back-end.
  let totalNumberOfCards: UInt?

  init?(state: AppState) {
    cards = state.cardSearch.cards
    totalNumberOfCards = state.cardSearch.totalNumberOfCards
  }
}

// MARK: - Helpers

extension CardSearchVM {
  /// The number of sections in the `collectionView`.
  var numberOfSections: Int {
    // Returns `2` if we should show the loading cell, otherwise 1 (only the section containing cards).
    shouldShowLoadingCell ? Section.allCases.count : Section.allCases.count - 1
  }

  /// The number of cards/cells in the `collectionView`.
  var numberOfCards: Int {
    cards.count
  }

  /// The `CardCellVM` for the corresponding `IndexPath` in the `collectionView`.
  func cardCellVM(at indexPath: IndexPath) -> CardCellVM {
    CardCellVM(imageURL: cards[safe: indexPath.item]?.imageURL)
  }

  /// Whether the loading cell should be shown.
  /// This cell is shown only if there are more cards to be fetched from back-end.
  var shouldShowLoadingCell: Bool {
    guard let totalNumberOfCards = totalNumberOfCards else {
      return true
    }

    return cards.count < totalNumberOfCards
  }
}
