//
//  HomeView.swift
//  HSMaster
//
//  Created by Davide Ruisi on 30/09/21.
//

import PinLayout
import Tempura

final class HomeView: UIView, ViewControllerModellableView {

  // MARK: - UI Elements

  let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

  // MARK: - SSUL

  func setup() {
    addSubview(collectionView)

    collectionView.dataSource = self
    collectionView.register(ArticleCardCell.self, forCellWithReuseIdentifier: ArticleCardCell.reuseIdentifier)
  }

  func style() {
    backgroundColor = .systemBackground
    collectionView.backgroundColor = .clear
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
    collectionViewLayout.estimatedItemSize = CGSize(width: collectionView.bounds.width, height: 50)
    collectionViewLayout.minimumLineSpacing = 16
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

    typedCell.model = ArticleCardCellVM(title: "Title", body: "Body", backgroundImage: nil)
    return typedCell
  }
}
