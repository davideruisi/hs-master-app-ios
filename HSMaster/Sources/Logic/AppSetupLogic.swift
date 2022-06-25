//
//  AppSetupLogic.swift
//  HSMaster
//
//  Created by Davide Ruisi on 28/11/21.
//

import Hydra
import Katana

extension Logic {
  /// Logic relative to the app setup.
  enum AppSetup {}
}

// MARK: - SideEffects

extension Logic.AppSetup {
  /// Starts the app setup, executing request to load app's content.
  struct Start: AppSideEffect, OnStartObserverDispatchable {
    func sideEffect(_ context: SideEffectContext<AppState, AppDependencies>) throws {
      context.dispatch(GetMetadata())
      context.dispatch(Logic.CardSearch.GetCardList())
    }
  }

  /// Get the Hearthstone game metadata from back-end.
  private struct GetMetadata: AppSideEffect {
    func sideEffect(_ context: SideEffectContext<AppState, AppDependencies>) throws {
      context.dependencies.networkManager.getMetadata()
        .then { metadata in
          context.dispatch(UpdateMetadataState(metadata: metadata))
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

extension Logic.AppSetup {
  /// Update the `Metadata` state.
  struct UpdateMetadataState: AppStateUpdater {
    let metadata: Models.Metadata

    func updateState(_ state: inout AppState) {
      state.metadata = metadata
    }
  }
}
