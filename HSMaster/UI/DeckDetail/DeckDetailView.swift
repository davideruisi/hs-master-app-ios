//
//  DeckDetailView.swift
//  HSMaster
//
//  Created by Davide Ruisi on 13/12/21.
//

import Tempura
import UIKit

/// The view showing the detail of a deck.
class DeckDetailView: UIView, ViewControllerModellableView {

  // MARK: - UI Constants

  static let collectionInset = SharedStyle.Spacing.medium
  static let collectionLineSpacing: CGFloat = SharedStyle.Spacing.xSmall

  // MARK: - UI Elements

  lazy var collectionView: UICollectionView = {
    UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
  }()

  // MARK: - Interaction

  /// The user tapped a CardCell.
  var didTapCardCell: CustomInteraction<IndexPath>?

  // MARK: - SSUL

  func setup() {
    addSubview(collectionView)

    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.register(DeckCardCell.self, forCellWithReuseIdentifier: DeckCardCell.reuseIdentifier)
  }

  func style() {
    Self.Style.collectionView(collectionView)
  }

  func update(oldModel: DeckDetailVM?) {
    guard let model = model, model != oldModel else {
      return
    }

    Self.Style.view(self, with: model.deck?.name)
    collectionView.reloadData()
  }

  override func layoutSubviews() {
    super.layoutSubviews()

    collectionView.pin
      .all()
  }
}

// MARK: - UICollectionViewDataSource

extension DeckDetailView: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    model?.numberOfCells ?? 0
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DeckCardCell.reuseIdentifier, for: indexPath)
    guard let typedCell = cell as? DeckCardCell else {
      return cell
    }
    typedCell.model = model?.deckCardCellVM(at: indexPath)
    return typedCell
  }
}

// MARK: - UICollectionViewDelegate

extension DeckDetailView: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    didTapCardCell?(indexPath)
  }
}

// MARK: - Styling Functions

private extension DeckDetailView {
  enum Style {
    static func view(_ view: DeckDetailView, with title: String?) {
      view.backgroundColor = Palette.backgroundPrimary.color
      view.navigationItem?.title = title
    }

    static func collectionView(_ collectionView: UICollectionView) {
      collectionView.backgroundColor = .clear
      collectionView.showsVerticalScrollIndicator = false
    }
  }
}

// MARK: - Helpers

private extension DeckDetailView {
  /// The `UICollectionViewLayout` for the `collectionView`.
  var collectionViewLayout: UICollectionViewLayout {
    let collectionViewLayout = UICollectionViewFlowLayout()
    collectionViewLayout.itemSize = CGSize(
      width: SharedStyle.portraitOrientationScreenWidth - 2 * Self.collectionInset,
      height: DeckCardCell.height
    )
    collectionViewLayout.minimumLineSpacing = Self.collectionLineSpacing
    collectionViewLayout.sectionInset = UIEdgeInsets(
      top: Self.collectionInset,
      left: Self.collectionInset,
      bottom: Self.collectionInset,
      right: Self.collectionInset
    )

    return collectionViewLayout
  }
}
