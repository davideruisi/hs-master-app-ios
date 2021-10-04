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
  let image: UIImage?
  let kicker: String
  let title: String
  let subtitle: String
}

// MARK: - View

/// A `UICollectionViewCell` displaying a card with a title, a body and an image for the relative article.
final class ArticleCardCell: UICollectionViewCell, ModellableView, ReusableView {

  // MARK: UI Elements

  let containerView = UIView()
  let imageView = UIImageView()
  let kickerLabel = UILabel()
  let titleLabel = UILabel()
  let subtitleLabel = UILabel()

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
    contentView.addSubview(containerView)
    containerView.addSubview(imageView)
    containerView.addSubview(kickerLabel)
    containerView.addSubview(titleLabel)
    containerView.addSubview(subtitleLabel)
  }

  func style() {
    Self.Style.contentView(contentView)
    Self.Style.containerView(containerView)
  }

  func update(oldModel: ArticleCardCellVM?) {
    Self.Style.imageView(imageView, with: model?.image)
    Self.Style.kickerLabel(kickerLabel, with: model?.kicker)
    Self.Style.titleLabel(titleLabel, with: model?.title)
    Self.Style.subtitleLabel(subtitleLabel, with: model?.subtitle)

    setNeedsLayout()
  }

  override func layoutSubviews() {
    super.layoutSubviews()

    performLayout()
  }

  private func performLayout() {
    containerView.pin.all()

    imageView.pin
      .top()
      .horizontally()
      .height(256)

    kickerLabel.pin
      .below(of: imageView)
      .marginTop(8)
      .horizontally(32)
      .sizeToFit(.width)

    titleLabel.pin
      .below(of: kickerLabel)
      .marginTop(8)
      .horizontally(32)
      .sizeToFit(.width)

    subtitleLabel.pin
      .below(of: titleLabel)
      .marginTop(8)
      .horizontally(32)
      .sizeToFit(.width)

    containerView.pin
      .wrapContent(.vertically, padding: PEdgeInsets(top: 0, left: 0, bottom: 32, right: 0))

    contentView.pin.wrapContent()
  }

  override func sizeThatFits(_ size: CGSize) -> CGSize {
    contentView.pin.width(size.width)
    performLayout()

    return CGSize(width: size.width, height: contentView.bounds.height)
  }
}

// MARK: - Styling Functions

private extension ArticleCardCell {
  enum Style {
    static func contentView(_ view: UIView) {
      view.layer.shadowColor = UIColor.black.cgColor
      view.layer.shadowOpacity = 0.1
      view.layer.shadowRadius = 8
      view.layer.shadowOffset = CGSize(width: 0, height: 4)
    }

    static func containerView(_ view: UIView) {
      view.backgroundColor = Palette.backgroundSecondary.color
      view.layer.cornerRadius = 32
      view.clipsToBounds = true
    }

    static func imageView(_ imageView: UIImageView, with image: UIImage?) {
      imageView.image = image
    }

    static func kickerLabel(_ label: UILabel, with text: String?) {
      label.text = text
    }

    static func titleLabel(_ label: UILabel, with text: String?) {
      label.text = text
    }

    static func subtitleLabel(_ label: UILabel, with text: String?) {
      label.text = text
    }
  }
}
