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
  /// The list of cards to be shown  in the `collectionView`.
  let cards: [Models.Card]

  init?(state: AppState) {
    cards = state.cards
  }
}

// MARK: - Helpers

extension CardSearchVM {
  var numberOfCards: Int {
    cards.count
  }

  func cardCellVM(at indexPath: IndexPath) -> CardCellVM {
    CardCellVM(imageURL: cards[safe: indexPath.item]?.imageURL)
  }
}
