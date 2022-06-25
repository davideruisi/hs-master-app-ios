//
//  CardDetailVC.swift
//  HSMaster
//
//  Created by Davide Ruisi on 30/11/21.
//

import Foundation
import Tempura

/// The ViewController of the CardDetailView.
final class CardDetailVC: ViewControllerWithLocalState<CardDetailView> {
  override func setupInteraction() {
    rootView.didTapCloseButton = { [weak self] in
      self?.dispatch(Hide(Screen.cardDetail, animated: true))
    }
  }
}
