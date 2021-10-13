//
//  HomeLogic.swift
//  HSMaster
//
//  Created by Davide Ruisi on 13/10/21.
//

import Katana

extension Logic {
  /// The Logic relative to the Home tab.
  enum Home {}
}

// MARK: - SideEffects

extension Logic.Home {
  /// Get articles from back-end. Then update the AppState with the new articles list.
  struct GetArticles: AppSideEffect {
    func sideEffect(_ context: SideEffectContext<AppState, AppDependencies>) throws {
      var newArticles = context.getState().articles

      for _ in 0..<5 {
        newArticles.append(
          Model.Article(
            imageURL: URL(string: "https://static.wikia.nocookie.net/hearthstone_gamepedia/images/4/4d/Greybough_full.jpg/revision/latest/scale-to-width-down/854?cb=20210123221359"),
            kicker: "Meta Report",
            title: "vS Data Reaper Report #208",
            body: "Welcome to the 208th edition of the Data Reaper Report! This is the first report following the nerfs to Warlock, Shaman, Priest, and Demon Hunter as well as buffs to Warrior, Mage, and Hunter."
          )
        )
      }

      // Simulate a delay due to the network request
      DispatchQueue.global().asyncAfter(deadline: .now() + 4.0) {
        context.dispatch(UpdateArticlesState(articles: newArticles))
      }
    }
  }
}

// MARK: - StateUpdaters

extension Logic.Home {
  /// Update the state with the `articles`.
  private struct UpdateArticlesState: AppStateUpdater {
    /// The new list of articles.
    let articles: [Model.Article]

    func updateState(_ state: inout AppState) {
      state.articles = articles
    }
  }
}
