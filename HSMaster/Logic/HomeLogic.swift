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
      var articles = context.getState().home.articles

      context.dependencies.contentfulManager.getArticles(offset: articles.count)
        .then { totalArticles, newArticles in
          articles.append(contentsOf: newArticles)

          context.dispatch(UpdateArticlesState(articles: articles, totalNumberOfArticles: totalArticles))
        }
        .catch { _ in
          // Executes again the request after a delay of 1 second.
          DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
            context.dispatch(self)
          }
        }
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

private extension Logic.Home {
  /// Update the state with the `articles`.
  /// The update is effectively done only if `articles` contains more articles than the current value in the state.
  /// This is needed to avoid any possible rase condition problem that can occur in `GetArticles` SideEffect.
  struct UpdateArticlesState: AppStateUpdater {
    /// The new list of articles.
    let articles: [Models.Article]

    /// The total number of articles available on back-end.
    let totalNumberOfArticles: UInt

    func updateState(_ state: inout AppState) {
      guard state.home.articles.count < articles.count else {
        return
      }

      state.home = AppState.Home(articles: articles, totalNumberOfArticles: totalNumberOfArticles)
    }
  }
}
