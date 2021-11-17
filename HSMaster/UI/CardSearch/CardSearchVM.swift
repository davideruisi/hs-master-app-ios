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

  init?(state: AppState) {
    cards = state.cardSearch.cards
  }
}

// MARK: - Helpers

extension CardSearchVM {
  /// The number of sections in the `collectionView`.
  var numberOfSections: Int {
    Section.allCases.count
  }

  /// The number of cards/cells in the `collectionView`.
  var numberOfCards: Int {
    cards.count
  }

  /// The `CardCellVM` for the corresponding `IndexPath` in the `collectionView`.
  func cardCellVM(at indexPath: IndexPath) -> CardCellVM {
    CardCellVM(imageURL: cards[safe: indexPath.item]?.imageURL)
  }
}
