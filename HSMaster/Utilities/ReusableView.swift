//
//  ReusableView.swift
//  HSMaster
//
//  Created by Davide Ruisi on 02/10/21.
//

import UIKit

/// A protocol that augments an `UIView` with a reuse identifier. Meant to be used for `UICollectionViewCell` and `UICollectionReusableView`.
public protocol ReusableView: UIView {
  /// The reusable identifier of the cell.
  static var reuseIdentifier: String { get }
}

public extension ReusableView {
  static var reuseIdentifier: String {
    String(describing: self.self)
  }
}
