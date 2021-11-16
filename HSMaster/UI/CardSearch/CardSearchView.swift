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
    collectionView.delegate = self
    collectionView.register(CardCell.self, forCellWithReuseIdentifier: CardCell.reuseIdentifier)
    collectionView.register(LoadingCell.self, forCellWithReuseIdentifier: LoadingCell.reuseIdentifier)
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
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    model?.numberOfSections ?? 0
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    guard let section = CardSearchVM.Section(rawValue: section) else {
      AppLogger.critical("Wrong section index: \(section).")
      return 0
    }

    switch section {
    case .cards:
      return model?.numberOfCards ?? 0

    case .loading:
      return 1
    }
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let section = CardSearchVM.Section(rawValue: indexPath.section) else {
      AppLogger.critical("Wrong section index: \(indexPath.section).")
      fatalError()
    }

    switch section {
    case .cards:
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardCell.reuseIdentifier, for: indexPath)
      guard let typedCell = cell as? CardCell else {
        return cell
      }
      typedCell.model = model?.cardCellVM(at: indexPath)
      return typedCell

    case .loading:
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LoadingCell.reuseIdentifier, for: indexPath)
      guard let typedCell = cell as? LoadingCell else {
        return cell
      }
      typedCell.activityIndicatorView.startAnimating()
      return typedCell
    }
  }
}

// MARK: - UICollectionViewDelegate

extension CardSearchView: UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    guard let section = CardSearchVM.Section(rawValue: indexPath.section) else {
      AppLogger.critical("Wrong section index: \(indexPath.section).")
      return .zero
    }

    switch section {
    case .cards:
      let itemWidth = (SharedStyle.portraitOrientationScreenWidth - 2 * Self.collectionInset - Self.collectionItemsSpacing) / 2
      let itemHeight = Self.collectionItemHeightWidthRatio * itemWidth
      return CGSize(width: itemWidth, height: itemHeight)

    case .loading:
      let itemWidth = (SharedStyle.portraitOrientationScreenWidth - 2 * Self.collectionInset)
      let itemHeight = LoadingCell.height
      return CGSize(width: itemWidth, height: itemHeight)
    }
  }
}

// MARK: - Helpers

private extension CardSearchView {
  /// The `UICollectionViewLayout` for the `collectionView`.
  var collectionViewLayout: UICollectionViewLayout {
    let collectionViewLayout = UICollectionViewFlowLayout()
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
