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

  static let cellMargin: CGFloat = 16

  // MARK: - UI Elements

  let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

  // MARK: - SSUL

  func setup() {
    addSubview(collectionView)

    collectionView.dataSource = self
    collectionView.register(ArticleCardCell.self, forCellWithReuseIdentifier: ArticleCardCell.reuseIdentifier)
  }

  func style() {
    Self.Style.view(self)
    Self.Style.collectionView(collectionView)
  }

  func update(oldModel: HomeVM?) {
    collectionView.reloadData()
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
    12
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ArticleCardCell.reuseIdentifier, for: indexPath)
    guard let typedCell = cell as? ArticleCardCell else {
      return cell
    }

    typedCell.model = ArticleCardCellVM(image: nil, kicker: "KICKER", title: "TITLE", subtitle: "Subtitle")
    return typedCell
  }
}
