//
//  Models.swift
//  HSMaster
//
//  Created by Davide Ruisi on 09/10/21.
//

import Foundation

/// Contains all the models used by the app.
enum Model {
  /// The Model of and Article that can be shown in the Home tab.
  struct Article {
    let imageURL: URL?
    let kicker: String?
    let title: String?
    let body: String?
  }
}
