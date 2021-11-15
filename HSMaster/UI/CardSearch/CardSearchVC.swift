//
//  CardSearchVC.swift
//  HSMaster
//
//  Created by Davide Ruisi on 09/11/21.
//

import Tempura

/// The ViewController of the `CardSearchView`.
final class CardSearchVC: ViewController<CardSearchView> {
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    dispatch(Logic.CardSearch.GetCardList())
  }
}
