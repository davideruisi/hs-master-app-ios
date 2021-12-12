//
//  CardDetailView.swift
//  HSMaster
//
//  Created by Davide Ruisi on 30/11/21.
//

import PinLayout
import Tempura
import UIKit

/// The view showing the detail of a card.
final class CardDetailView: UIView, ViewControllerModellableView {

  // MARK: - Constants

  static let cardImageRatio: CGFloat = 375.0 / 518.0

  // MARK: - UI Elements

  let scrollView = UIScrollView()
  let containerView = UIView()
  let cardImageView = UIImageView()
  let flavorTextLabel = UILabel()
  let setDetailView = DetailView()
  let classDetailView = DetailView()
  let keywordDetailView = DetailView()
  let artistDetailView = DetailView()

  // MARK: - Interactions

  var didTapCloseButton: Interaction?

  // MARK: - SSUL

  func setup() {
    addSubview(scrollView)
    scrollView.addSubview(containerView)
    containerView.addSubview(cardImageView)
    containerView.addSubview(flavorTextLabel)
    containerView.addSubview(setDetailView)
    containerView.addSubview(classDetailView)
    containerView.addSubview(keywordDetailView)
    containerView.addSubview(artistDetailView)

    navigationItem?.rightBarButtonItem = UIBarButtonItem(
      barButtonSystemItem: .close,
      target: self,
      action: #selector(tappedCloseButton)
    )
  }

  func style() {
    Self.Style.view(self)
    Self.Style.scrollView(scrollView)
  }

  func update(oldModel: CardDetailVM?) {
    Self.Style.cardImageView(cardImageView, with: model?.card.imageURL)
    Self.Style.navigationItem(navigationItem, with: model?.card.name)

    Self.Style.flavorTextLabel(flavorTextLabel, with: model?.card.flavorText)

    setDetailView.model = model?.setDetailVM
    classDetailView.model = model?.classDetailVM
    keywordDetailView.model = model?.keywordDetailVM
    artistDetailView.model = model?.artistDetailVM
  }

  override func layoutSubviews() {
    super.layoutSubviews()

    scrollView.pin
      .all()

    containerView.pin
      .top()
      .horizontally()

    cardImageView.pin
      .horizontally(SharedStyle.Spacing.large)
      .aspectRatio(Self.cardImageRatio)

    flavorTextLabel.pin
      .below(of: cardImageView)
      .marginTop(SharedStyle.Spacing.medium)
      .horizontally(SharedStyle.Spacing.medium)
      .sizeToFit(.width)

    setDetailView.pin
      .below(of: flavorTextLabel)
      .marginTop(SharedStyle.Spacing.large)
      .horizontally(SharedStyle.Spacing.medium)
      .sizeToFit(.width)

    classDetailView.pin
      .below(of: setDetailView)
      .horizontally(SharedStyle.Spacing.medium)
      .sizeToFit(.width)

    keywordDetailView.pin
      .below(of: classDetailView)
      .horizontally(SharedStyle.Spacing.medium)
      .sizeToFit(.width)

    artistDetailView.pin
      .below(of: keywordDetailView)
      .horizontally(SharedStyle.Spacing.medium)
      .sizeToFit(.width)

    containerView.pin
      .wrapContent(.vertically, padding: SharedStyle.Spacing.small)

    scrollView.contentSize = CGSize(width: scrollView.frame.width, height: containerView.frame.height)
  }
}

// MARK: - Styling Functions

extension CardDetailView {
  enum Style {
    static func view(_ view: CardDetailView) {
      view.backgroundColor = Palette.backgroundPrimary.color
    }

    static func navigationItem(_ navigationItem: UINavigationItem?, with title: String?) {
      navigationItem?.title = title
    }

    static func scrollView(_ scrollView: UIScrollView) {
      scrollView.showsVerticalScrollIndicator = false
    }

    static func cardImageView(_ imageView: UIImageView, with url: URL?) {
      imageView.contentMode = .scaleAspectFit
      imageView.kf.setImage(with: url, options: [.transition(.fade(0.3))])
    }

    static func flavorTextLabel(_ label: UILabel, with text: String?) {
      label.text = text
      label.font = .italicSystemFont(ofSize: 18)
      label.numberOfLines = 0
      label.textAlignment = .center
    }
  }
}

// MARK: - Helpers

private extension CardDetailView {
  @objc
  func tappedCloseButton() {
    didTapCloseButton?()
  }
}
