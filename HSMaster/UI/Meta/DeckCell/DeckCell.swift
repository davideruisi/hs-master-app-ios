//
//  DeckCell.swift
//  HSMaster
//
//  Created by Davide Ruisi on 08/12/21.
//

import Foundation
import Tempura

// MARK: - ViewModel

/// The `ViewModel` for the `DeckCell`.
struct DeckCellVM: ViewModel {
  let classImage: UIImage?
  let name: String?
}

// MARK: - View

/// The `UICollectionViewCell` for a deck in the Meta tab.
class DeckCell: UICollectionViewCell, ModellableView, ReusableView {

  // MARK: Constants

  static let classImageSize: CGFloat = 50

  // MARK: UI Elements

  let containerView = UIView()
  let classImageView = UIImageView()
  let nameLabel = UILabel()

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
    containerView.addSubview(classImageView)
    containerView.addSubview(nameLabel)
  }

  func style() {
    Self.Style.contentView(contentView)
    Self.Style.containerView(containerView)
  }

  func update(oldModel: DeckCellVM?) {
    Self.Style.classImageView(classImageView, with: model?.classImage)
    Self.Style.nameLabel(nameLabel, with: model?.name)

    setNeedsLayout()
  }

  override func layoutSubviews() {
    super.layoutSubviews()

    performLayout()
  }

  private func performLayout() {
    containerView.pin
      .all()

    classImageView.pin
      .left(SharedStyle.Spacing.medium)
      .size(Self.classImageSize)

    nameLabel.pin
      .after(of: classImageView)
      .marginLeft(SharedStyle.Spacing.medium)
      .right()
      .sizeToFit(.width)

    containerView.pin
      .wrapContent(.vertically, padding: SharedStyle.Spacing.medium)

    classImageView.pin
      .vCenter()

    nameLabel.pin
      .vCenter()
  }

  override func sizeThatFits(_ size: CGSize) -> CGSize {
    contentView.pin.width(size.width)
    performLayout()

    return containerView.frame.size
  }
}

// MARK: - Styling Functions

private extension DeckCell {
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
    }

    static func classImageView(_ view: UIImageView, with image: UIImage?) {
      view.image = image
    }

    static func nameLabel(_ label: UILabel, with text: String?) {
      label.text = text
    }
  }
}
