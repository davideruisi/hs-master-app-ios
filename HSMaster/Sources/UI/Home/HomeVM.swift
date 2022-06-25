//
//  HomeVM.swift
//  HSMaster
//
//  Created by Davide Ruisi on 30/09/21.
//

import Tempura

/// The ViewModel of the `HomeView`.
struct HomeVM: ViewModelWithState, Equatable {

  // MARK: Stored Properties

  /// The list of articles to show in the collection view.
  let articles: [Models.Article]

  /// The total number of articles that can be fetched from back-end.
  let totalNumberOfArticles: UInt?

  /// Whether the view is refreshing after a pull to refresh.
  let isRefreshing: Bool

  // MARK: Computed Properties

  /// Whether the loading skeleton cell should be shown.
  /// This cell is shown only if there are more articles to be fetched from back-end.
  var shouldShowSkeletonCell: Bool {
    guard let totalNumberOfArticles = totalNumberOfArticles else {
      return true
    }

    return articles.count < totalNumberOfArticles
  }

  // MARK: Init

  init?(state: AppState) {
    articles = state.home.articles
    totalNumberOfArticles = state.home.totalNumberOfArticles
    isRefreshing = state.home.isRefreshing
  }
}

// MARK: - Helpers

extension HomeVM {
  /// The number of `ArticleCell`s of the collection in `HomeView`.
  var numberOfArticleCells: Int {
    articles.count
  }

  /// The `ViewModel` for the `ArticleCell` at the specified `IndexPath`.
  /// - Parameter indexPath: The `IndexPath` of the cell.
  /// - Returns: The `ViewModel` of the cell in the specified `IndexPath`
  func articleCellVM(at indexPath: IndexPath) -> ArticleCellVM? {
    guard let article = articles[safe: indexPath.row] else {
      return nil
    }

    return ArticleCellVM(
      imageURL: article.imageURL,
      kicker: article.kicker,
      title: article.title,
      subtitle: article.subtitle
    )
  }

  /// The `IndexPath`s for the new articles fetched from back-end (not present in the `oldModel`).
  /// - Parameter oldModel: The old `HomeVM`.
  /// - Returns: The `IndexPath`s for the articles in the new `HomeVM` not present in the old `HomeVM`.
  func newArticleCellsIndexes(from oldModel: HomeVM) -> [IndexPath] {
    if shouldEndRefreshing(from: oldModel) {
      // If the new articles come after a refresh we should add them on top of the list
      return (0 ..< articles.count - oldModel.articles.count).map { IndexPath(item: $0, section: 0) }
    } else {
      // Otherwise they come after scrolling for a new page. In this case we should add them on the bottom of the list.
      return (oldModel.articles.count ..< articles.count).map { IndexPath(item: $0, section: 0) }
    }
  }

  /// The `IndexPath` of the loading skeleton cell.
  var skeletonCellIndex: IndexPath {
    IndexPath(item: articles.count, section: 0)
  }

  /// Whether we should handle the end of a refreshing.
  func shouldEndRefreshing(from oldModel: HomeVM) -> Bool {
    return oldModel.isRefreshing && !isRefreshing
  }
}
