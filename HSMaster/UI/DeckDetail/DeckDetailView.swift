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
  let activityIndicatorView = UIActivityIndicatorView()

  // MARK: - Interaction

  /// The user tapped a CardCell.
  var didTapCardCell: CustomInteraction<IndexPath>?

  /// The user tapped the button to copy the deck's code.
  var didTapCopyCodeButton: Interaction?

  // MARK: - SSUL

  func setup() {
    addSubview(collectionView)
    addSubview(activityIndicatorView)

    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.register(DeckCardCell.self, forCellWithReuseIdentifier: DeckCardCell.reuseIdentifier)

    navigationItem?.rightBarButtonItem = UIBarButtonItem(
      title: nil,
      style: .plain,
      target: self,
      action: #selector(tappedCopyCodeButton)
    )
  }

  func style() {
    Self.Style.view(self)
    Self.Style.collectionView(collectionView)
  }

  func update(oldModel: DeckDetailVM?) {
    guard let model = model, model != oldModel else {
      return
    }

    Self.Style.navigationItem(
      navigationItem,
      title: model.deck?.name,
      rightBarButtonItemTitle: model.navigationBarRightButtonItemTitle
    )

    Self.Style.activityIndicatorView(activityIndicatorView, isVisible: model.shouldShowLoader)

    collectionView.reloadData()
  }

  override func layoutSubviews() {
    super.layoutSubviews()

    activityIndicatorView.pin
      .vCenter()
      .hCenter()
      .sizeToFit()

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
    static func view(_ view: DeckDetailView) {
      view.backgroundColor = HSMasterAsset.Colors.backgroundPrimary.color
    }

    static func navigationItem(_ navigationItem: UINavigationItem?, title: String?, rightBarButtonItemTitle: String?) {
      navigationItem?.title = title
      navigationItem?.rightBarButtonItem?.title = rightBarButtonItemTitle
    }

    static func activityIndicatorView(_ view: UIActivityIndicatorView, isVisible: Bool) {
      isVisible ? view.startAnimating() : view.stopAnimating()
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

  @objc
  func tappedCopyCodeButton() {
    didTapCopyCodeButton?()
  }
}
