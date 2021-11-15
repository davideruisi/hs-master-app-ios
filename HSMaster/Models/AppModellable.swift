//
//  AppModellable.swift
//  HSMaster
//
//  Created by Davide Ruisi on 14/11/21.
//

/// External Models that adhere to this protocol can be translated to the corresponding App Models.
protocol AppModellable {
  associatedtype AppModel

  /// Obtain the corresponding `AppModel`.
  func toAppModel() -> AppModel
}

extension Array where Element: AppModellable {
  func toAppModel() -> [Element.AppModel] {
    map { $0.toAppModel() }
  }
}
