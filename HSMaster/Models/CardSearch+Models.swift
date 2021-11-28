//
//  CardSearch+Models.swift
//  HSMaster
//
//  Created by Davide Ruisi on 28/11/21.
//

import Foundation

extension Models {
  /// Models relative to the CardSearch tab.
  enum CardSearch {}
}

extension Models.CardSearch {
  /// The filter applied to the card search.
  struct Filter: Equatable {
    /// The text filter taken from the search-bar.
    let text: String
  }
}

extension Models.CardSearch.Filter {
  init() {
    text = ""
  }
}
