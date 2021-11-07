//
//  AppState.swift
//  HSMaster
//
//  Created by Davide Ruisi on 22/09/21.
//

import Foundation
import Katana

/// The state of the app.
struct AppState: State {
  /// The list of articles already fetched from back-end to be shown in the Home tab.
  var articles: [Models.Article]

  /// The total number of articles available on back-end.
  var totalNumberOfArticles: UInt?
}

// MARK: - Empty Init

extension AppState {
  init() {
    totalNumberOfArticles = nil
    articles = []
  }
}
