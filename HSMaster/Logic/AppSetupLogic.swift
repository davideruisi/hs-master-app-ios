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
  /// Get the Hearthstone game metadata from back-end.
  struct GetMetadata: AppSideEffect {
    func sideEffect(_ context: SideEffectContext<AppState, AppDependencies>) throws {
      let metadata = try Hydra.await(context.dependencies.networkManager.getMetadata())
      context.dispatch(UpdateMetadataState(metadata: metadata))
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
