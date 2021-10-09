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
    articles = {
      var articles: [Model.Article] = []

      for _ in 0..<15 {
        articles.append(
          Model.Article(
            imageURL: URL(string: "https://static.wikia.nocookie.net/hearthstone_gamepedia/images/4/4d/Greybough_full.jpg/revision/latest/scale-to-width-down/854?cb=20210123221359"),
            kicker: "Meta Report",
            title: "vS Data Reaper Report #208",
            body: "Welcome to the 208th edition of the Data Reaper Report! This is the first report following the nerfs to Warlock, Shaman, Priest, and Demon Hunter as well as buffs to Warrior, Mage, and Hunter."
          )
        )
      }

      return articles
    }()
  }
}
