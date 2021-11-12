//
//  ArticleCell.swift
//  HSMaster
//
//  Created by Davide Ruisi on 01/10/21.
//

import PinLayout
import Tempura

// MARK: - ViewModel

/// The `ViewModel` for `ArticleCell`.
struct ArticleCellVM: ViewModel {
  let imageURL: URL?
  let kicker: String?
  let title: String?
  let subtitle: String?
}

// MARK: - View

/// A `UICollectionViewCell` displaying a card with a title, a body and an image for the relative article.
final class ArticleCell: UICollectionViewCell, ModellableView, ReusableView {

  // MARK: Constants

  private static let imageViewRatio: CGFloat = 5 / 3

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

  func update(oldModel: ArticleCellVM?) {
    Self.Style.imageView(imageView, with: model?.imageURL)
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
      .aspectRatio(Self.imageViewRatio)

    kickerLabel.pin
      .below(of: imageView)
      .marginTop(SharedStyle.Spacing.medium)
      .horizontally(SharedStyle.Spacing.large)
      .sizeToFit(.width)

    titleLabel.pin
      .below(of: kickerLabel)
      .marginTop(SharedStyle.Spacing.small)
      .horizontally(SharedStyle.Spacing.large)
      .sizeToFit(.width)

    subtitleLabel.pin
      .below(of: titleLabel)
      .marginTop(SharedStyle.Spacing.small)
      .horizontally(SharedStyle.Spacing.large)
      .sizeToFit(.width)

    containerView.pin
      .wrapContent(.vertically, padding: PEdgeInsets(top: 0, left: 0, bottom: SharedStyle.Spacing.large, right: 0))
  }

  override func sizeThatFits(_ size: CGSize) -> CGSize {
    contentView.pin.width(size.width)
    performLayout()

    return CGSize(width: size.width, height: containerView.bounds.height)
  }
}

// MARK: - Styling Functions

private extension ArticleCell {
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

    static func imageView(_ imageView: UIImageView, with url: URL?) {
      imageView.contentMode = .scaleAspectFill
      imageView.clipsToBounds = true
      imageView.kf.setImage(with: url)
    }

    static func kickerLabel(_ label: UILabel, with text: String?) {
      label.text = text?.uppercased()
      label.numberOfLines = 1
      label.font = .systemFont(ofSize: 16, weight: .semibold)
      label.textColor = .secondaryLabel
    }

    static func titleLabel(_ label: UILabel, with text: String?) {
      label.text = text?.uppercased()
      label.numberOfLines = 3
      label.font = .systemFont(ofSize: 32, weight: .bold)
      label.textColor = .label
    }

    static func subtitleLabel(_ label: UILabel, with text: String?) {
      label.text = text
      label.numberOfLines = 2
      label.font = .systemFont(ofSize: 16, weight: .regular)
      label.textColor = .secondaryLabel
    }
  }
}
