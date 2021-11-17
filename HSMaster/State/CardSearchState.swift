//
//  CardSearchState.swift
//  HSMaster
//
//  Created by Davide Ruisi on 17/11/21.
//

import Katana

extension AppState {
  /// The state of the CardSearch tab.
  struct CardSearch {
    /// The list of card that can be shown in the Card Search tab.
    var cards: [Models.Card]

    /// The last received page of the card list.
    var lastReceivedPage: Int?

    /// The total number of cards available on back-end.
    var totalNumberOfCards: UInt?
  }
}

extension AppState.CardSearch {
  init() {
    cards = []
    lastReceivedPage = nil
    totalNumberOfCards = nil
  }
}
