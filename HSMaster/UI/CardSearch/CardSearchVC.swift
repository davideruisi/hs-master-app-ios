//
//  CardSearchVC.swift
//  HSMaster
//
//  Created by Davide Ruisi on 09/11/21.
//

import Tempura

/// The ViewController of the `CardSearchView`.
final class CardSearchVC: ViewController<CardSearchView> {
  override func setupInteraction() {
    rootView.didReachLoadingCell = { [weak self] in
      self?.dispatch(Logic.CardSearch.GetCardList())
    }

    rootView.didChangeSearchBarText = { [weak self] text in
      self?.dispatch(Logic.CardSearch.UpdateFilterState(text: text))
    }

    rootView.didTapCardCell = { [weak self] indexPath in
      guard let card = self?.viewModel?.card(for: indexPath) else {
        return
      }

      self?.dispatch(Logic.CardSearch.ShowCardDetail(card: card))
    }
  }
}
