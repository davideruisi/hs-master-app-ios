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
  static let collectionItemHeightWidthRatio = 518.0 / 375.0

  // MARK: UI Elements

  lazy var collectionView: UICollectionView = {
    UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
  }()

  // MARK: Interactions

  /// Called when the user reaches the end of the cards list and we need to fetch more cards from beck-end.
  var didReachLoadingCell: Interaction?

  /// Called when the user changes the text filter in the search-bar.
  var didChangeSearchBarText: CustomInteraction<String>?

  /// The user tapped a card cell in the `collectionView`.
  var didTapCardCell: CustomInteraction<IndexPath>?

  // MARK: SSUL

  func setup() {
    addSubview(collectionView)

    setupCollectionView()
    setupSearchBar()
  }

  func style() {
    Self.Style.view(self)
    Self.Style.collectionView(collectionView)
  }

  func update(oldModel: CardSearchVM?) {
    guard let model = model else {
      return
    }

    Self.Style.searchBar(navigationItem?.searchController?.searchBar, with: model.searchBarText)
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

    static func searchBar(_ searchBar: UISearchBar?, with text: String?) {
      searchBar?.text = text
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

      // Signals we have reached the end of the cards list.
      didReachLoadingCell?()

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

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    didTapCardCell?(indexPath)
  }
}

// MARK: - UISearchBarDelegate

extension CardSearchView: UISearchBarDelegate {
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    didChangeSearchBarText?("")
  }

  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    didChangeSearchBarText?(searchBar.text ?? "")
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

  func setupCollectionView() {
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.register(CardCell.self, forCellWithReuseIdentifier: CardCell.reuseIdentifier)
    collectionView.register(LoadingCell.self, forCellWithReuseIdentifier: LoadingCell.reuseIdentifier)
  }

  func setupSearchBar() {
    guard let navigationItem = navigationItem else {
      AppLogger.error("Missing instance of \(UINavigationItem.self).")
      return
    }

    let search = UISearchController(searchResultsController: nil)
    search.obscuresBackgroundDuringPresentation = false
    search.searchBar.placeholder = Localization.CardSearchTab.SearchBar.placeholder
    search.searchBar.delegate = self
    navigationItem.searchController = search
    navigationItem.hidesSearchBarWhenScrolling = false
  }
}
