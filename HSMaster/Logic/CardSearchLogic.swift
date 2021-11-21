//
//  CardSearchLogic.swift
//  HSMaster
//
//  Created by Davide Ruisi on 14/11/21.
//

import Hydra
import Katana

extension Logic {
  /// The logic relative to the CardSearch tab.
  enum CardSearch {}
}

// MARK: - SideEffects

extension Logic.CardSearch {
  /// Executes a request to get a page of cards list and update the state with the received cards.
  struct GetCardList: AppSideEffect {
    func sideEffect(_ context: SideEffectContext<AppState, AppDependencies>) throws {
      let nextPage = context.getState().cardSearch.lastReceivedPage + 1

      var cards = context.getState().cardSearch.cards

      let (totalNumberOfCards, newCards) = try Hydra.await(context.dependencies.networkManager.getCardList(page: nextPage))

      cards.append(contentsOf: newCards)

      context.dispatch(
        UpdateCardsStateIfPossible(
          cards: cards,
          requestedPage: nextPage,
          totalNumberOfCards: totalNumberOfCards
        )
      )
    }
  }
}

// MARK: - StateUpdaters

fileprivate extension Logic.CardSearch.GetCardList {
  /// Update the list of cards in the App state if possible.
  /// The state is only updated if the request parameters are yet the same.
  /// (It can happens that the user has changed filters while the request was executing).
  struct UpdateCardsStateIfPossible: AppStateUpdater {
    /// The new list of cards to be saved in the state.
    let cards: [Models.Card]

    /// The requested page.
    let requestedPage: Int

    /// The total number of cards available on back-end.
    let totalNumberOfCards: UInt

    func updateState(_ state: inout AppState) {
      guard requestedPage == state.cardSearch.lastReceivedPage + 1 else {
        return
      }

      state.cardSearch = AppState.CardSearch(
        cards: cards,
        totalNumberOfCards: totalNumberOfCards,
        lastReceivedPage: requestedPage
      )
    }
  }
}
