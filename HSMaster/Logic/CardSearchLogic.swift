//
//  CardSearchLogic.swift
//  HSMaster
//
//  Created by Davide Ruisi on 14/11/21.
//

import Hydra
import Katana

extension Logic {
  enum CardSearch {}
}

extension Logic.CardSearch {
  /// Execute a request to get the cards list and update the state with the received cards.
  struct GetCardList: AppSideEffect {
    func sideEffect(_ context: SideEffectContext<AppState, AppDependencies>) throws {
      let cards = try Hydra.await(context.dependencies.networkManager.getCardList())

      context.dispatch(UpdateCardsState(cards: cards))
    }
  }
}

extension Logic.CardSearch {
  /// Update the list of cards in the App state.
  struct UpdateCardsState: AppStateUpdater {
    /// The new list of cards to be saved in the state.
    let cards: [Models.Card]

    func updateState(_ state: inout AppState) {
      state.cards = cards
    }
  }
}
