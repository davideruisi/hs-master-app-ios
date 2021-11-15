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
  struct GetCardList: AppSideEffect {
    func sideEffect(_ context: SideEffectContext<AppState, AppDependencies>) throws {
      let cards = try Hydra.await(context.dependencies.networkManager.getCardList())

      context.dispatch(UpdateCardsState(cards: cards))
    }
  }
}

extension Logic.CardSearch {
  struct UpdateCardsState: AppStateUpdater {

    let cards: [Models.Card]

    func updateState(_ state: inout AppState) {
      state.cards = cards
    }
  }
}
