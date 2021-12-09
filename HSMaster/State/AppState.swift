//
//  AppState.swift
//  HSMaster
//
//  Created by Davide Ruisi on 22/09/21.
//

import Katana

/// The state of the app.
struct AppState: State {
  /// The state of the Home tab.
  var home: Home

  /// The state of the CardSearch tab.
  var cardSearch: CardSearch

  /// The state of the Meta tab.
  var meta: Meta

  /// The Hearthstone metadata.
  var metadata: Models.Metadata
}

// MARK: - Empty Init

extension AppState {
  init() {
    home = Home()
    cardSearch = CardSearch()
    meta = Meta()
    metadata = Models.Metadata()
  }
}
