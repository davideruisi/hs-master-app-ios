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
  /// The list of articles to be shown in the Home tab.
  var articles: [Model.Article]
}

// MARK: - Empty Init

extension AppState {
  init() {
    articles = []
  }
}
