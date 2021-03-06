//
//  MetaState.swift
//  HSMaster
//
//  Created by Davide Ruisi on 08/12/21.
//

import Katana

extension AppState {
  /// The state of the Home tab.
  struct Meta {
    /// The list of decks fetched from back-end to be shown in the Meta tab.
    var decks: [Models.Deck]

    /// Whether the Meta tab is refreshing.
    var isRefreshing: Bool
  }
}

extension AppState.Meta {
  init() {
    decks = []
    isRefreshing = false
  }
}
