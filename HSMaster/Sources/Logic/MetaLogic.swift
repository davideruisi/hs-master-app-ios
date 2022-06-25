//
//  MetaLogic.swift
//  HSMaster
//
//  Created by Davide Ruisi on 09/12/21.
//

import Hydra
import Katana
import Tempura

extension Logic {
  /// The Logic relative to the Meta tab.
  enum Meta {}
}

// MARK: - SideEffects

extension Logic.Meta {
  /// Download the Meta decks from back-end and save them to state.
  /// For each retrieved deck then requests the detail.
  struct GetMetaDecks: AppSideEffect {
    func sideEffect(_ context: SideEffectContext<AppState, AppDependencies>) throws {
      context.dependencies.contentfulManager.getDecks()
        .then { decks in
          try Hydra.await(context.dispatch(UpdateMetaDecksState(decks: decks)))

          decks.forEach { deck in
            context.dispatch(GetDeckDetail(deck: deck))
          }
        }
        .catch { _ in
          // Executes again the request after a delay of 1 second.
          DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
            context.dispatch(self)
          }
        }
    }
  }

  /// Gets the Details of the specified Deck from back-end and updates the state of the deck adding the detail.
  struct GetDeckDetail: AppSideEffect {
    let deck: Models.Deck

    func sideEffect(_ context: SideEffectContext<AppState, AppDependencies>) throws {
      context.dependencies.networkManager.getDeckDetail(with: deck.code)
        .then { detail in
          context.dispatch(UpdateMetaDeckStateAddingDetail(deck: deck, detail: detail))
        }
        .catch { _ in
          // Executes again the request after a delay of 1 second.
          DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
            context.dispatch(self)
          }
        }
    }
  }

  /// Shows the view containing the detail of the `deck`.
  struct ShowDeckDetail: AppSideEffect {
    /// The deck that will be shown in the detail view.
    let deck: Models.Deck?

    func sideEffect(_ context: SideEffectContext<AppState, AppDependencies>) throws {
      guard let deckIndex = context.getState().meta.decks.firstIndex(where: { $0.code == deck?.code }) else {
        AppLogger.error("Missing Deck with code \(String(describing: deck?.code)) in state.")
        return
      }

      let deckDetailLS = DeckDetailLS(deckIndex: deckIndex, deckCodeCopied: false)
      context.dispatch(Show(Screen.deckDetail, animated: true, context: deckDetailLS))
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

  /// Updates the App State adding the `detail` to the `deck`.
  struct UpdateMetaDeckStateAddingDetail: AppStateUpdater {
    /// The deck to which the detail will be added.
    let deck: Models.Deck

    /// The detail to be added on the deck.
    let detail: Models.Deck.Detail

    func updateState(_ state: inout AppState) {
      guard let deckIndex = state.meta.decks.firstIndex(where: { $0.code == deck.code }) else {
        AppLogger.error("Missing Deck with code \(deck.code) in state.")
        return
      }

      state.meta.decks[deckIndex] = Models.Deck(
        name: deck.name,
        tier: deck.tier,
        position: deck.position,
        code: deck.code,
        detail: detail
      )
    }
  }
}
