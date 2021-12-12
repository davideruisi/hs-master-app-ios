//
//  CardCellView.swift
//  HSMaster
//
//  Created by Davide Ruisi on 09/11/21.
//

import Foundation
import Tempura

/// The ViewModel of the `CardCell`.
struct CardCellVM: ViewModel {
  /// The URL of the image of the card shown in the cell.
  let imageURL: URL?
}

/// A cell showing a card.
final class CardCell: UICollectionViewCell, ModellableView, ReusableView {

  // MARK: UI Elements

  let cardImageView = UIImageView()

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
    contentView.addSubview(cardImageView)
  }

  func style() {}

  func update(oldModel: CardCellVM?) {
    Self.Style.cardImageView(cardImageView, with: model?.imageURL)

    setNeedsLayout()
  }

  override func layoutSubviews() {
    super.layoutSubviews()

    cardImageView.pin
      .all()
  }
}

// MARK: - Styling Functions

private extension CardCell {
  enum Style {
    static func cardImageView(_ view: UIImageView, with url: URL?) {
      view.contentMode = .scaleAspectFit
      view.kf.setImage(with: url, options: [.transition(.fade(0.3))])
    }
  }
}
