//
//  CardDetailVM.swift
//  HSMaster
//
//  Created by Davide Ruisi on 30/11/21.
//

import Foundation
import Tempura

// MARK: - ViewModel

/// The ViewModel of the CardDetailView.
struct CardDetailVM: ViewModelWithLocalState {

  // MARK: Stored Properties

  /// The game metadata.
  private let metadata: Models.Metadata?

  /// The card shown in the detail view.
  let card: Models.Card

  // MARK: Init

  init?(state: AppState?, localState: CardDetailLS) {
    metadata = state?.metadata
    card = localState.card
  }
}

// MARK: - ViewModel Helpers

extension CardDetailVM {

  // MARK: Set Detail

  var cardSet: Models.Metadata.Set? {
    metadata?.getSet(with: card.setId)
  }

  var isSetDetailHidden: Bool {
    cardSet == nil
  }

  var setDetailBody: NSAttributedString? {
    NSAttributedString(string: cardSet?.name ?? "")
  }

  var setDetailVM: DetailVM {
    DetailVM(title: HSMasterStrings.CardDetail.set, body: setDetailBody, isHidden: isSetDetailHidden)
  }

  // MARK: Class Detail

  var cardClasses: [Models.Metadata.Class] {
    card.classIds.compactMap { metadata?.getClass(with: $0) }
  }

  var isClassDetailHidden: Bool {
    cardClasses.isEmpty
  }

  var classDetailBody: NSAttributedString? {
    guard let firstClass = cardClasses.first else {
      return nil
    }

    let string = cardClasses.dropFirst().reduce(firstClass.name) { "\($0), \($1.name)" }

    return NSAttributedString(string: string)
  }

  var classDetailVM: DetailVM {
    DetailVM(title: HSMasterStrings.CardDetail.class, body: classDetailBody, isHidden: isClassDetailHidden)
  }

  // MARK: Keyword Detail

  var keywords: [Models.Metadata.Keyword] {
    card.keywordIds.compactMap { metadata?.getKeyword(with: $0) }
  }

  var isKeywordDetailHidden: Bool {
    keywords.isEmpty
  }

  var keywordDetailBody: NSAttributedString? {
    guard let firstKeyword = keywords.first else {
      return nil
    }

    let boldFont = UIFont.systemFont(ofSize: 18, weight: .bold)

    let attributedString = NSMutableAttributedString(
      string: firstKeyword.name,
      attributes: [.font: boldFont]
    )
    attributedString.append(NSAttributedString(string: ": \"\(firstKeyword.description)\""))

    _ = keywords.dropFirst().reduce(into: attributedString) {
      $0.append(NSAttributedString(string: "\n\($1.name)", attributes: [.font: boldFont]))
      $0.append(NSAttributedString(string: ": \"\($1.description)\""))
    }

    return attributedString
  }

  var keywordDetailVM: DetailVM {
    DetailVM(title: HSMasterStrings.CardDetail.keywords, body: keywordDetailBody, isHidden: isKeywordDetailHidden)
  }

  // MARK: Artist Detail

  var artistDetailVM: DetailVM {
    guard let artistName = card.artistName else {
      return DetailVM(title: nil, body: nil, isHidden: true)
    }

    return DetailVM(title: HSMasterStrings.CardDetail.artist, body: NSAttributedString(string: artistName), isHidden: false)
  }
}

// MARK: - LocalState

/// The LocalState of the CardDetailView.
struct CardDetailLS: LocalState {
  /// The card shown in the detail view.
  let card: Models.Card
}
