//
//  Models.swift
//  HSMaster
//
//  Created by Davide Ruisi on 09/10/21.
//

import Foundation

/// Contains all the models used by the app.
enum Models {
  /// The Model of and Article that can be shown in the Home tab.
  struct Article: Equatable {
    let imageURL: URL?
    let kicker: String?
    let title: String?
    let subtitle: String?
    let sourceURL: URL?
  }

  /// The Model of a card.
  struct Card: Equatable {
    /// The URL of the card image.
    let imageURL: URL?
  }
}
