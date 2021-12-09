//
//  MetaVC.swift
//  HSMaster
//
//  Created by Davide Ruisi on 07/12/21.
//

import Foundation
import Tempura

/// The ViewController of the `MetaView`.
class MetaVC: ViewController<MetaView> {
  override func viewDidLoad() {
    super.viewDidLoad()

    dispatch(Logic.Meta.GetMetaDecks())
  }
}
