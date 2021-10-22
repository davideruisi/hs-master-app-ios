//
//  HomeView.swift
//  HSMaster
//
//  Created by Davide Ruisi on 30/09/21.
//

import PinLayout
import Tempura

/// The main view of the Home tab. It contains news and articles.
final class HomeView: UIView, ViewControllerModellableView {

  // MARK: - Constants

  static let cellMargin: CGFloat = SharedStyle.Spacing.medium

  // MARK: - UI Elements

  let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

  // MARK: - Interactions

  /// Called when the user reaches the end of the articles list and we need to fetch more articles.
  var didReachSkeletonCell: Interaction?

  // MARK: - SSUL

  func setup() {
    addSubview(collectionView)

    collectionView.dataSource = self
    collectionView.register(ArticleCardCell.self, forCellWithReuseIdentifier: ArticleCardCell.reuseIdentifier)
    collectionView.register(ArticleCardSkeletonCell.self, forCellWithReuseIdentifier: ArticleCardSkeletonCell.reuseIdentifier)
  }

  func style() {
    Self.Style.view(self)
    Self.Style.collectionView(collectionView)
  }

  func update(oldModel: HomeVM?) {
    guard let model = model, model != oldModel else {
      return
    }

    // The first time (when oldModel is nil) reload the whole collection, otherwise update only the cells that need to be updated.
    if let oldModel = oldModel {
      collectionView.performBatchUpdates {
        // Delete the loading skeleton cell when no more needed.
        if !model.shouldShowSkeletonCell {
          collectionView.deleteItems(at: [oldModel.skeletonCellIndex])
        }
        // Insert the new articles cells in the collection.
        collectionView.insertItems(at: model.newArticleCardCellsIndexes(from: oldModel))
      }
    } else {
      collectionView.reloadData()
    }
  }

  override func layoutSubviews() {
    collectionView.pin
      .all()

    updateAfterLayout()
  }

  private func updateAfterLayout() {
    guard
      let collectionViewLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout,
      collectionViewLayout.estimatedItemSize == .zero // avoid multiple adjust iteration
    else {
      return
    }
    collectionViewLayout.itemSize = UICollectionViewFlowLayout.automaticSize
    collectionViewLayout.estimatedItemSize = CGSize(width: collectionView.bounds.width - 2 * Self.cellMargin, height: 256)
    collectionViewLayout.minimumLineSpacing = Self.cellMargin * 2
    collectionViewLayout.sectionInset = UIEdgeInsets(
      top: Self.cellMargin,
      left: Self.cellMargin,
      bottom: Self.cellMargin,
      right: Self.cellMargin
    )
  }
}

// MARK: - Styling Functions

private extension HomeView {
  enum Style {
    static func view(_ view: HomeView) {
      view.backgroundColor = Palette.backgroundPrimary.color
    }

    static func collectionView(_ collectionView: UICollectionView) {
      collectionView.backgroundColor = .clear
    }
  }
}

// MARK: - UICollectionViewDataSource

extension HomeView: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    guard let model = model else {
      return 0
    }

    if model.shouldShowSkeletonCell {
      // We return 1 more than the `numberOfArticleCardCells` for the loading skeleton cell.
      return model.numberOfArticleCardCells + 1
    } else {
      return model.numberOfArticleCardCells
    }
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let numberOfArticles = model?.numberOfArticleCardCells ?? 0

    // If the indexPath is for an article, dequeue an ArticleCardCell.
    // Otherwise, dequeue an ArticleCardSkeletonView and signal the reach of the end of the collection.
    if indexPath.row < numberOfArticles {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ArticleCardCell.reuseIdentifier, for: indexPath)
      guard let typedCell = cell as? ArticleCardCell else {
        return cell
      }
      typedCell.model = model?.articleCardCellVM(at: indexPath)
      return typedCell
    } else {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ArticleCardSkeletonCell.reuseIdentifier, for: indexPath)
      didReachSkeletonCell?()
      return cell
    }
  }
}
