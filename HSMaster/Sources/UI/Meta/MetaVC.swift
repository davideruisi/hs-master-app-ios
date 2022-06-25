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
  override func setupInteraction() {
    rootView.didTapDeckCell = { [weak self] indexPath in
      let deck = self?.viewModel?.deck(for: indexPath)

      self?.dispatch(Logic.Meta.ShowDeckDetail(deck: deck))
    }
  }
}
