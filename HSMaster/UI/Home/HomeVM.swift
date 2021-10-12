//
//  HomeVM.swift
//  HSMaster
//
//  Created by Davide Ruisi on 30/09/21.
//

import Tempura

/// The ViewModel of the `HomeView`.
struct HomeVM: ViewModelWithState {
  /// The list of articles to show in the collection view.
  let articles: [Model.Article]

  init?(state: AppState) {
    articles = state.articles
  }
}

// MARK: - Helpers

extension HomeVM {
  /// The number of `ArticleCardCell`s of the collection in `HomeView`.
  var numberOfArticleCardCells: Int {
    articles.count
  }

  /// The `ViewModel` for the `ArticleCardCell` at the specified `IndexPath`.
  /// - Parameter indexPath: The `IndexPath` of the cell.
  /// - Returns: The `ViewModel` of the cell in the specified `IndexPath`
  func articleCardCellVM(at indexPath: IndexPath) -> ArticleCardCellVM? {
    guard let article = articles[safe: indexPath.row] else {
      return nil
    }

    return ArticleCardCellVM(
      imageURL: article.imageURL,
      kicker: article.kicker,
      title: article.title,
      subtitle: article.body
    )
  }
}
