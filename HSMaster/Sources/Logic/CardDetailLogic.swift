//
//  CardDetailLogic.swift
//  HSMaster
//
//  Created by Davide Ruisi on 14/12/21.
//

import Katana
import Tempura

extension Logic {
  enum CardDetail {}
}

extension Logic.CardDetail {
  /// Shows the view containing the detail of the `card`.
  struct ShowCardDetail: AppSideEffect {
    /// The card that will be shown in the detail view.
    let card: Models.Card

    func sideEffect(_ context: SideEffectContext<AppState, AppDependencies>) throws {
      let cardDetailLS = CardDetailLS(card: card)
      context.dispatch(Show(Screen.cardDetail, animated: true, context: cardDetailLS))
    }
  }
}
