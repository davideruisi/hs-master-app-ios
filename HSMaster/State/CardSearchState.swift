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

    /// The total number of cards available on back-end.
    var totalNumberOfCards: UInt?

    /// The last received page of the card list.
    /// The first page is `1`. If the value is `0`, no page has been yet received
    var lastReceivedPage: Int
  }
}

extension AppState.CardSearch {
  init() {
    cards = []
    totalNumberOfCards = nil
    lastReceivedPage = 0
  }
}
