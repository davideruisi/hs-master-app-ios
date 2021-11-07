//
//  HomeLogic.swift
//  HSMaster
//
//  Created by Davide Ruisi on 13/10/21.
//

import Hydra
import Katana
import Tempura

extension Logic {
  /// The Logic relative to the Home tab.
  enum Home {}
}

// MARK: - SideEffects

extension Logic.Home {
  /// Get articles from back-end. Then update the AppState with the new articles list.
  struct GetArticles: AppSideEffect {
    func sideEffect(_ context: SideEffectContext<AppState, AppDependencies>) throws {
      var articles = context.getState().articles

      let (totalArticles, newArticles) = try Hydra.await(
        context.dependencies.contentfulManager.getArticles(offset: articles.count)
      )

      articles.append(contentsOf: newArticles)

      context.dispatch(UpdateArticlesState(articles: articles, totalNumberOfArticles: totalArticles))
    }
  }

  /// Show a Safari web-view with the URL of the article.
  struct ShowArticleInWebView: AppSideEffect {
    /// The article to be shown in the web-view.
    let article: Models.Article?

    func sideEffect(_ context: SideEffectContext<AppState, AppDependencies>) throws {
      guard let article = article else {
        AppLogger.error("Missing instance of \(Models.Article.self)")
        return
      }

      guard let url = article.sourceURL else {
        AppLogger.error("Missing instance of \(URL.self)")
        return
      }

      context.dispatch(Show(Screen.safariWebView, animated: true, context: url))
    }
  }
}

// MARK: - StateUpdaters

extension Logic.Home {
  /// Update the state with the `articles`.
  private struct UpdateArticlesState: AppStateUpdater {
    /// The new list of articles.
    let articles: [Models.Article]

    /// The total number of articles available on back-end.
    let totalNumberOfArticles: UInt

    func updateState(_ state: inout AppState) {
      state.articles = articles
      state.totalNumberOfArticles = totalNumberOfArticles
    }
  }
}
