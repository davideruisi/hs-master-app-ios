//
//  DetailView.swift
//  HSMaster
//
//  Created by Davide Ruisi on 06/12/21.
//

import Foundation
import PinLayout
import Tempura
import UIKit

// MARK: - ViewModel

/// The ViewModel of `DetailView`.
struct DetailVM: ViewModel {
  let title: String?
  let body: NSAttributedString?
  let isHidden: Bool
}

// MARK: - View

/// A view containing a title and a body for a card detail.
final class DetailView: UIView, ModellableView {

  // MARK: UI Elements

  let containerView = UIView()
  let titleLabel = UILabel()
  let bodyLabel = UILabel()
  let separatorView = UIView()

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
    addSubview(containerView)
    containerView.addSubview(titleLabel)
    containerView.addSubview(bodyLabel)
    containerView.addSubview(separatorView)
  }

  func style() {
    Self.Style.separatorView(separatorView)
  }

  func update(oldModel: DetailVM?) {
    guard let model = model else {
      return
    }

    Self.Style.view(self, isHidden: model.isHidden)
    Self.Style.titleLabel(titleLabel, with: model.title)
    Self.Style.bodyLabel(bodyLabel, with: model.body)
  }

  override func layoutSubviews() {
    super.layoutSubviews()

    performLayout()
  }

  private func performLayout() {
    guard let model = model else {
      return
    }

    if model.isHidden {
      containerView.pin
        .top()
        .horizontally()
        .height(0)
    } else {
      containerView.pin
        .horizontally()

      separatorView.pin
        .horizontally()
        .height(2)

      titleLabel.pin
        .below(of: separatorView)
        .marginTop(SharedStyle.Spacing.medium)
        .horizontally()
        .sizeToFit(.width)

      bodyLabel.pin
        .below(of: titleLabel)
        .marginTop(SharedStyle.Spacing.xSmall)
        .horizontally()
        .sizeToFit(.width)

      containerView.pin
        .wrapContent(.vertically, padding: PEdgeInsets(top: 0, left: 0, bottom: SharedStyle.Spacing.medium, right: 0))
    }
  }

  override func sizeThatFits(_ size: CGSize) -> CGSize {
    pin.width(size.width)
    performLayout()

    return CGSize(width: containerView.frame.width, height: containerView.frame.height)
  }
}

// MARK: Styling Functions

extension DetailView {
  enum Style {
    static func view(_ view: UIView, isHidden: Bool) {
      view.isHidden = isHidden
    }

    static func titleLabel(_ label: UILabel, with text: String?) {
      label.text = text
      label.font = .systemFont(ofSize: 20, weight: .bold)
    }

    static func bodyLabel(_ label: UILabel, with attributedText: NSAttributedString?) {
      label.attributedText = attributedText
      label.numberOfLines = 0
    }

    static func separatorView(_ view: UIView) {
      view.backgroundColor = Palette.backgroundTertiary.color
    }
  }
}
