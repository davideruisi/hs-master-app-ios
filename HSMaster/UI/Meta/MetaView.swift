//
//  MetaView.swift
//  HSMaster
//
//  Created by Davide Ruisi on 07/12/21.
//

import Foundation
import Tempura

/// The View containing the meta tier list with the best decks.
class MetaView: UIView, ViewControllerModellableView {

  // MARK: - UI Constants

  static let collectionInset = SharedStyle.Spacing.medium
  static let collectionLineSpacing = SharedStyle.Spacing.medium

  // MARK: - UI Elements

  lazy var collectionView: UICollectionView = {
    UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
  }()

  // MARK: - Interaction

  /// The user tapped a DeckCell.
  var didTapDeckCell: CustomInteraction<IndexPath>?

  // MARK: - SSUL

  func setup() {
    addSubview(collectionView)

    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.register(DeckCell.self, forCellWithReuseIdentifier: DeckCell.reuseIdentifier)
  }

  func style() {
    Self.Style.view(self)
    Self.Style.collectionView(collectionView)
  }

  func update(oldModel: MetaVM?) {
    guard let model = model, model != oldModel else {
      return
    }

    collectionView.reloadData()
  }

  override func layoutSubviews() {
    super.layoutSubviews()

    collectionView.pin
      .all()
  }
}

// MARK: - UICollectionViewDataSource

extension MetaView: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    model?.numberOfCells ?? 0
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DeckCell.reuseIdentifier, for: indexPath)
    guard let typedCell = cell as? DeckCell else {
      return cell
    }
    typedCell.model = model?.deckCellVM(at: indexPath)
    return typedCell
  }
}

// MARK: - UICollectionViewDelegate

extension MetaView: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    didTapDeckCell?(indexPath)
  }
}

// MARK: - Styling Functions

private extension MetaView {
  enum Style {
    static func view(_ view: MetaView) {
      view.backgroundColor = Palette.backgroundPrimary.color
    }

    static func collectionView(_ collectionView: UICollectionView) {
      collectionView.backgroundColor = .clear
    }
  }
}

// MARK: - Helpers

private extension MetaView {
  /// The `UICollectionViewLayout` for the `collectionView`.
  var collectionViewLayout: UICollectionViewLayout {
    let collectionViewLayout = UICollectionViewFlowLayout()
    collectionViewLayout.itemSize = UICollectionViewFlowLayout.automaticSize
    collectionViewLayout.estimatedItemSize = CGSize(
      width: SharedStyle.portraitOrientationScreenWidth - 2 * Self.collectionInset,
      height: 64
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
