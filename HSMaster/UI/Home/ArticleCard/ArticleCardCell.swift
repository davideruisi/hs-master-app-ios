//
//  ArticleCardCell.swift
//  HSMaster
//
//  Created by Davide Ruisi on 01/10/21.
//

import PinLayout
import Tempura

// MARK: - ViewModel

/// The `ViewModel` for `ArticleCardCell`.
struct ArticleCardCellVM: ViewModel {
  let title: String
  let body: String
  let backgroundImage: UIImage?
}

// MARK: - View

/// A `UICollectionViewCell` displaying a card with a title, a body and an image for the relative article.
final class ArticleCardCell: UICollectionViewCell, ModellableView, ReusableView {

  static let containerInset: CGFloat = 25
  static let cellInset: CGFloat = 25
  static let chevronInset: CGFloat = 30
  static let chevronSize: CGFloat = 24
  static let titleToChevron: CGFloat = 15

  // MARK: UI Elements

  let titleLabel = UILabel()
  let bodyLabel = UILabel()
  let backgroundImageView = UIImageView()

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
    contentView.addSubview(backgroundImageView)
    contentView.addSubview(titleLabel)
    contentView.addSubview(bodyLabel)
  }

  func style() {
    contentView.backgroundColor = .gray
  }

  func update(oldModel: ArticleCardCellVM?) {
    titleLabel.text = model?.title
    bodyLabel.text = model?.body
    backgroundImageView.image = model?.backgroundImage

    setNeedsLayout()
  }

  override func layoutSubviews() {
    super.layoutSubviews()

    pin.height(128)

    titleLabel.pin
      .top(32)
      .horizontally(32)
      .sizeToFit(.content)

    bodyLabel.pin
      .below(of: titleLabel)
      .marginTop(16)
      .horizontally(32)
      .bottom(32)

    backgroundImageView.pin
      .all()
  }

  override func sizeThatFits(_ size: CGSize) -> CGSize {
    let labelWidth = size.width - 2 * Self.containerInset - Self.cellInset - Self.chevronSize - Self.chevronInset
    let titleSize = self.titleLabel.sizeThatFits(CGSize(width: labelWidth, height: CGFloat.infinity))
    return CGSize(width: size.width, height: 128)
  }
}
