//
//  CardSearchLogic.swift
//  HSMaster
//
//  Created by Davide Ruisi on 14/11/21.
//

import Hydra
import Katana
import Tempura

extension Logic {
  /// The logic relative to the CardSearch tab.
  enum CardSearch {}
}

// MARK: - SideEffects

extension Logic.CardSearch {
  /// Executes a request to get a page of cards list and update the state with the received cards.
  struct GetCardList: AppSideEffect {
    func sideEffect(_ context: SideEffectContext<AppState, AppDependencies>) throws {
      let filter = context.getState().cardSearch.filter

      let nextPage = context.getState().cardSearch.lastReceivedPage + 1

      var cards = context.getState().cardSearch.cards

      context.dependencies.networkManager.getCardList(filter: filter, page: nextPage)
        .then { totalNumberOfCards, newCards in
          cards.append(contentsOf: newCards)

          context.dispatch(
            UpdateCardsStateIfPossible(
              cards: cards,
              requestFilter: filter,
              requestedPage: nextPage,
              totalNumberOfCards: totalNumberOfCards
            )
          )
        }
        .catch { _ in
          // Executes again the request after a delay of 1 second.
          DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
            context.dispatch(self)
          }
        }
    }
  }
}

// MARK: - StateUpdaters

extension Logic.CardSearch {
  /// Update the list of cards in the App state if possible.
  /// The state is only updated if the request parameters are yet the same.
  /// (It can happens that the user has changed filters while the request was executing).
  struct UpdateCardsStateIfPossible: AppStateUpdater {
    /// The new list of cards to be saved in the state.
    let cards: [Models.Card]

    /// The filter applied to the request.
    let requestFilter: Models.CardSearch.Filter

    /// The requested page.
    let requestedPage: Int

    /// The total number of cards available on back-end.
    let totalNumberOfCards: UInt

    func updateState(_ state: inout AppState) {
      guard
        requestedPage == state.cardSearch.lastReceivedPage + 1,
        requestFilter == state.cardSearch.filter
      else {
        return
      }

      state.cardSearch = AppState.CardSearch(
        cards: cards,
        totalNumberOfCards: totalNumberOfCards,
        lastReceivedPage: requestedPage,
        filter: state.cardSearch.filter
      )
    }
  }

  /// Update the filter of the CardSearch state.
  /// If the filter changed, reset completely the `CardSearch` state to invalidate previous search.
  struct UpdateFilterState: AppStateUpdater {
    let text: String

    func updateState(_ state: inout AppState) {
      let newFilterState = Models.CardSearch.Filter(
        text: text
      )

      if newFilterState != state.cardSearch.filter {
        state.cardSearch = AppState.CardSearch()
        state.cardSearch.filter = newFilterState
      }
    }
  }
}
