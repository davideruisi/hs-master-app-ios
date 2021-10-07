//
//  SharedStyle.swift
//  HSMaster
//
//  Created by Davide Ruisi on 08/10/21.
//

import UIKit

/// An enum containing style utilities.
enum SharedStyle {
  /// The corner radius of cards in the app.
  static let cardCornerRadius: CGFloat = 32

  /// The spacing used to arrange UI elements in the app.
  enum Spacing {
    /// A spacing of 4.
    static let extraSmall: CGFloat = 4

    /// A spacing of 8.
    static let small: CGFloat = 8

    /// A spacing of 16.
    static let medium: CGFloat = 16

    /// A spacing of 32.
    static let large: CGFloat = 32

    /// A spacing of 64.
    static let extraLarge: CGFloat = 64
  }
}
