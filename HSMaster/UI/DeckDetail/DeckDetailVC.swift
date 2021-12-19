//
//  DeckDetailVC.swift
//  HSMaster
//
//  Created by Davide Ruisi on 13/12/21.
//

import Foundation
import Tempura

/// The ViewController of the DeckDetailView.
final class DeckDetailVC: ViewControllerWithLocalState<DeckDetailView> {
  override func setupInteraction() {
    rootView.didTapCardCell = { [weak self] indexPath in
      guard let card = self?.viewModel?.card(for: indexPath) else {
        return
      }

      self?.dispatch(Logic.CardDetail.ShowCardDetail(card: card))
    }
  }
}
