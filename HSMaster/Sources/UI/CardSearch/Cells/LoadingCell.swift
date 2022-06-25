//
//  LoadingCell.swift
//  HSMaster
//
//  Created by Davide Ruisi on 15/11/21.
//

import Tempura

/// A `UICollectionViewCell` displaying an `UIActivityIndicatorView`.
final class LoadingCell: UICollectionViewCell, View, ReusableView {

  // MARK: Constants

  static let height: CGFloat = 50

  // MARK: UI Elements

  let activityIndicatorView = UIActivityIndicatorView()

  // MARK: Init

  override init(frame: CGRect) {
    super.init(frame: frame)

    setup()
    style()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: SSUL

  func setup() {
    contentView.addSubview(activityIndicatorView)
  }

  func style() {}

  func update() {}

  override func layoutSubviews() {
    super.layoutSubviews()

    activityIndicatorView.pin
      .all()
  }
}
