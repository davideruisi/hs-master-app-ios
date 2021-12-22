//
//  TierSectionHeader.swift
//  HSMaster
//
//  Created by Davide Ruisi on 21/12/21.
//

import Tempura

// MARK: - ViewModel

/// The `ViewModel` for the `DeckCell`.
struct TierSectionHeaderVM: ViewModel {
  let title: String
}

// MARK: - View

/// The `UICollectionViewCell` for a deck in the Meta tab.
class TierSectionHeader: UICollectionReusableView, ModellableView, ReusableView {

  // MARK: Constants

  static let height = SharedStyle.Spacing.large

  // MARK: UI Elements

  let titleLabel = UILabel()

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
    addSubview(titleLabel)
  }

  func style() {}

  func update(oldModel: TierSectionHeaderVM?) {
    Self.Style.titleLabel(titleLabel, with: model?.title)
  }

  override func layoutSubviews() {
    super.layoutSubviews()

    titleLabel.pin
      .bottom()
      .horizontally(SharedStyle.Spacing.large)
      .sizeToFit(.width)
  }
}

// MARK: Styling Functions

extension TierSectionHeader {
  enum Style {
    static func titleLabel(_ label: UILabel, with text: String?) {
      label.text = text
      label.numberOfLines = 1
      label.font = .systemFont(ofSize: 16, weight: .semibold)
      label.textColor = .secondaryLabel
    }
  }
}
