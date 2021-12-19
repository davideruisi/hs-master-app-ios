//
//  DeckCardCell.swift
//  HSMaster
//
//  Created by Davide Ruisi on 13/12/21.
//

import Foundation
import Tempura
import UIKit

// MARK: - ViewModel

/// The ViewModel of the `DeckCardCell`.
struct DeckCardCellVM: ViewModel {
  /// The URL of the cropped image of the card shown in the cell.
  let croppedCardImageURL: URL?

  /// The card mana cost.
  let manaCost: Int

  /// The card name.
  let name: String

  /// The number of times the card is present in the deck.
  let quantity: Int
}

// MARK: - View

/// The cell of a card in the deck for the `DeckDetailView`.
class DeckCardCell: UICollectionViewCell, ModellableView, ReusableView {

  // MARK: Constants

  static let height: CGFloat = 50
  static let cornerRadius: CGFloat = 15
  static let croppedCardImageRatio: CGFloat = 243.0 / 64.0

  // MARK: UI Elements

  let containerView = UIView()
  let croppedCardImageView = UIImageView()
  let croppedCardGradientView = GradientView()
  let manaCostLabel = UILabel()
  let nameLabel = UILabel()
  let quantityLabel = UILabel()

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
    containerView.addSubview(croppedCardImageView)
    containerView.addSubview(croppedCardGradientView)
    containerView.addSubview(manaCostLabel)
    containerView.addSubview(nameLabel)
    containerView.addSubview(quantityLabel)
  }

  func style() {
    Self.Style.contentView(contentView)
    Self.Style.containerView(containerView)
    Self.Style.croppedCardGradientView(croppedCardGradientView)
  }

  func update(oldModel: DeckCardCellVM?) {
    guard let model = model else {
      return
    }

    Self.Style.croppedCardImageView(croppedCardImageView, with: model.croppedCardImageURL)
    Self.Style.manaCostLabel(manaCostLabel, with: model.manaCost)
    Self.Style.nameLabel(nameLabel, with: model.name)
    Self.Style.quantityLabel(quantityLabel, with: model.quantity)

    setNeedsLayout()
  }

  override func layoutSubviews() {
    super.layoutSubviews()

    containerView.pin
      .all()

    manaCostLabel.pin
      .vertically()
      .left()
      .aspectRatio(1)

    quantityLabel.pin
      .vertically()
      .right()
      .aspectRatio(1)

    croppedCardImageView.pin
      .before(of: quantityLabel)
      .vertically()
      .aspectRatio(Self.croppedCardImageRatio)

    croppedCardGradientView.pin
      .before(of: quantityLabel)
      .vertically()
      .aspectRatio(Self.croppedCardImageRatio)

    nameLabel.pin
      .vertically()
      .horizontallyBetween(manaCostLabel, and: quantityLabel)
      .marginLeft(SharedStyle.Spacing.small)
      .marginRight(SharedStyle.Spacing.small)
  }
}

// MARK: - Styling Functions

extension DeckCardCell {
  enum Style {
    static func contentView(_ view: UIView) {
      view.layer.shadowColor = UIColor.black.cgColor
      view.layer.shadowOpacity = 0.1
      view.layer.shadowRadius = 8
      view.layer.shadowOffset = CGSize(width: 0, height: 4)
    }

    static func containerView(_ view: UIView) {
      view.backgroundColor = Palette.backgroundSecondary.color
      view.layer.cornerRadius = DeckCardCell.cornerRadius
      view.clipsToBounds = true
    }

    static func croppedCardImageView(_ imageView: UIImageView, with url: URL?) {
      imageView.kf.setImage(with: url, options: [.transition(.fade(0.3))])
    }

    static func croppedCardGradientView(_ view: GradientView) {
      view.startColor = Palette.backgroundSecondary.color
      view.endColor = .clear
      view.startLocation = 0.25
      view.endLocation = 0.75
      view.horizontalMode = true
    }

    static func manaCostLabel(_ label: UILabel, with value: Int) {
      label.text = "\(value)"
      label.font = .systemFont(ofSize: 17, weight: .bold)
      label.textAlignment = .center
      label.textColor = .white
      label.backgroundColor = .systemBlue
    }

    static func nameLabel(_ label: UILabel, with text: String) {
      label.text = text
      label.font = .systemFont(ofSize: 17, weight: .bold)
      label.textColor = .label
    }

    static func quantityLabel(_ label: UILabel, with value: Int) {
      label.text = "\(value)"
      label.font = .systemFont(ofSize: 17, weight: .bold)
      label.textAlignment = .center
      label.textColor = .label
      label.backgroundColor = Palette.backgroundTertiary.color
    }
  }
}
