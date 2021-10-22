//
//  ArticleCardSkeletonCell.swift
//  HSMaster
//
//  Created by Davide Ruisi on 11/10/21.
//

import PinLayout
import SkeletonView
import Tempura

/// A skeleton of the ArticleCardCell to be used when loading content.
final class ArticleCardSkeletonCell: UICollectionViewCell, View, ReusableView {

  // MARK: Constants

  private static let imageViewRatio: CGFloat = 5 / 3
  private static let labelHeight: CGFloat = 65

  // MARK: UI Elements

  let containerView = UIView()
  let imageView = UIImageView()
  let label = UILabel()

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
    containerView.addSubview(label)
  }

  func style() {
    Self.Style.contentView(contentView)
    Self.Style.containerView(containerView)
    Self.Style.imageView(imageView)
    Self.Style.label(label)

    showSkeleton()
  }

  func update() {}

  override func layoutSubviews() {
    super.layoutSubviews()

    performLayout()
  }

  private func performLayout() {
    containerView.pin.all()

    imageView.pin
      .horizontally(SharedStyle.Spacing.xSmall)
      .aspectRatio(Self.imageViewRatio)

    label.pin
      .below(of: imageView)
      .marginTop(SharedStyle.Spacing.medium)
      .horizontally(SharedStyle.Spacing.large)
      .height(Self.labelHeight)

    containerView.pin
      .wrapContent(
        .vertically,
        padding: PEdgeInsets(
          top: SharedStyle.Spacing.xSmall,
          left: 0,
          bottom: SharedStyle.Spacing.large,
          right: 0
        )
      )
  }

  override func sizeThatFits(_ size: CGSize) -> CGSize {
    contentView.pin.width(size.width)
    performLayout()

    return CGSize(width: size.width, height: containerView.bounds.height)
  }
}

// MARK: - Styling Functions

private extension ArticleCardSkeletonCell {
  enum Style {
    static func contentView(_ view: UIView) {
      view.layer.shadowColor = UIColor.black.cgColor
      view.layer.shadowOpacity = 0.1
      view.layer.shadowRadius = 8
      view.layer.shadowOffset = CGSize(width: 0, height: 4)
    }

    static func containerView(_ view: UIView) {
      view.backgroundColor = Palette.backgroundSecondary.color
      view.layer.cornerRadius = SharedStyle.cardCornerRadius
      view.clipsToBounds = true

      view.isSkeletonable = true
    }

    static func imageView(_ imageView: UIImageView) {
      imageView.layer.cornerRadius = SharedStyle.cardCornerRadius
      imageView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
      imageView.clipsToBounds = true

      imageView.isSkeletonable = true
    }

    static func label(_ label: UILabel) {
      label.numberOfLines = 3

      label.isSkeletonable = true
      label.linesCornerRadius = 8
    }
  }
}

// MARK: - Helpers

private extension ArticleCardSkeletonCell {
  /// Start the skeleton loading animation on the cell.
  func showSkeleton() {
    let skeletonGradient = SkeletonGradient(
      baseColor: Palette.backgroundPrimary.color,
      secondaryColor: Palette.backgroundSecondary.color
    )
    containerView.showAnimatedGradientSkeleton(usingGradient: skeletonGradient)
  }
}
