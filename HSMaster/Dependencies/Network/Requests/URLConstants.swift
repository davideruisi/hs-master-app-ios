//
//  URLConstants.swift
//  HSMaster
//
//  Created by Davide Ruisi on 15/11/21.
//

import Foundation

// swiftlint:disable force_unwrapping

/// Base URL constants.
enum BaseURL {
  /// The battle.net authentication server base URL.
  static let authentication = URL(string: "https://us.battle.net/oauth")!

  /// The official Blizzard Hearthstone API base URL.
  static let hearthstone = URL(string: "https://us.api.blizzard.com/hearthstone")!
}
