//
//  MetaLogic.swift
//  HSMaster
//
//  Created by Davide Ruisi on 09/12/21.
//

import Hydra
import Katana

extension Logic {
  /// The Logic relative to the Meta tab.
  enum Meta {}
}

// MARK: - SideEffects

extension Logic.Meta {
  /// Download the Meta decks from back-end and save them to state.
  struct GetMetaDecks: AppSideEffect {
    func sideEffect(_ context: SideEffectContext<AppState, AppDependencies>) throws {
      let decks = try Hydra.await(context.dependencies.contentfulManager.getDecks())

      context.dispatch(UpdateMetaDecksState(decks: decks))
    }
  }
}

// MARK: - StateUpdaters

extension Logic.Meta {
  /// Update the App State with the downloaded meta decks.
  struct UpdateMetaDecksState: AppStateUpdater {
    let decks: [Models.Deck]

    func updateState(_ state: inout AppState) {
      state.meta.decks = decks
    }
  }
}
