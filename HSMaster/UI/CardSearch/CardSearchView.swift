//
//  CardSearchView.swift
//  HSMaster
//
//  Created by Davide Ruisi on 09/11/21.
//

import Foundation
import Tempura
import UIKit

/// The view where users can search cards.
final class CardSearchView: UIView, ViewControllerModellableView {

  // MARK: Constant

  static let collectionInset = SharedStyle.Spacing.small
  static let collectionItemsSpacing = SharedStyle.Spacing.xSmall
  static let collectionItemHeightWidthRatio = 1.4

  // MARK: UI Elements

  lazy var collectionView: UICollectionView = {
    UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
  }()

  // MARK: SSUL

  func setup() {
    addSubview(collectionView)

    collectionView.dataSource = self
    collectionView.register(CardCell.self, forCellWithReuseIdentifier: CardCell.reuseIdentifier)
  }

  func style() {
    Self.Style.view(self)
    Self.Style.collectionView(collectionView)
  }

  func update(oldModel: CardSearchVM?) {
    collectionView.reloadData()
  }

  override func layoutSubviews() {
    super.layoutSubviews()

    collectionView.pin
      .all()
  }
}

// MARK: - Styling Functions

private extension CardSearchView {
  enum Style {
    static func view(_ view: CardSearchView) {
      view.backgroundColor = Palette.backgroundPrimary.color
    }

    static func collectionView(_ collectionView: UICollectionView) {
      collectionView.backgroundColor = .clear
    }
  }
}

// MARK: - UICollectionViewDataSource

extension CardSearchView: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    12
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardCell.reuseIdentifier, for: indexPath)
    guard let typedCell = cell as? CardCell else {
      return cell
    }
    typedCell.model = CardCellVM(imageURL: URL(string: "https://d15f34w2p8l1cc.cloudfront.net/hearthstone/583cc7d410d87bfcd1b22f5623e348b9cc9a58cdca85524be2d7c9327c583a20.png")!)
    return typedCell
  }
}

// MARK: - Helpers

private extension CardSearchView {
  /// The `UICollectionViewLayout` for the `collectionView`.
  var collectionViewLayout: UICollectionViewLayout {
    let collectionViewLayout = UICollectionViewFlowLayout()
    let itemWidth = (SharedStyle.portraitOrientationScreenWidth - 2 * Self.collectionInset - Self.collectionItemsSpacing) / 2
    let itemHeight = Self.collectionItemHeightWidthRatio * itemWidth
    collectionViewLayout.itemSize = CGSize(width: itemWidth, height: itemHeight)
    collectionViewLayout.minimumLineSpacing = Self.collectionItemsSpacing
    collectionViewLayout.minimumInteritemSpacing = Self.collectionItemsSpacing
    collectionViewLayout.sectionInset = UIEdgeInsets(
      top: Self.collectionInset,
      left: Self.collectionInset,
      bottom: Self.collectionInset,
      right: Self.collectionInset
    )

    return collectionViewLayout
  }
}
