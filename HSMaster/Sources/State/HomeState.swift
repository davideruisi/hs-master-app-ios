//
//  HomeState.swift
//  HSMaster
//
//  Created by Davide Ruisi on 17/11/21.
//

import Katana

extension AppState {
  /// The state of the Home tab.
  struct Home {
    /// The list of articles already fetched from back-end to be shown in the Home tab.
    var articles: [Models.Article]

    /// The total number of articles available on back-end.
    var totalNumberOfArticles: UInt?

    /// Whether the Home is refreshing.
    var isRefreshing: Bool
  }
}

extension AppState.Home {
  init() {
    articles = []
    totalNumberOfArticles = nil
    isRefreshing = false
  }
}
