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
  let decks: [Models.Deck]

  init?(state: AppState) {
    decks = state.meta.decks
  }
}

// MARK: - Helpers

extension MetaVM {
  /// The number of cells in the `collectionView`.
  var numberOfCells: Int {
    // decks.count
    15
  }

  /// Creates the `ViewModel` for the `DeckCell` at the specified `indexPath`.
  /// - Parameter indexPath: The `IndexPath` of the `DeckCell` for which we want the `ViewModel`
  /// - Returns: The `DeckCellVM` for the specified `indexPath`.
  func deckCellVM(at indexPath: IndexPath) -> DeckCellVM {
    DeckCellVM(
      classImage: TabBarController.Tab.meta.selectedImage,
      name: "Prova"
    )
  }
}
