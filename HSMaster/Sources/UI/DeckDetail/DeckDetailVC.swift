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
        AppLogger.critical("Missing instance of \(Models.Card.self).")
        return
      }

      self?.dispatch(Logic.CardDetail.ShowCardDetail(card: card))
    }

    rootView.didTapCopyCodeButton = { [weak self] in
      guard let self = self else {
        AppLogger.critical("Missing instance of \(Self.self).")
        return
      }

      UIPasteboard.general.string = self.viewModel?.deck?.code
      self.localState = DeckDetailLS(deckIndex: self.localState.deckIndex, deckCodeCopied: true)
    }
  }
}
