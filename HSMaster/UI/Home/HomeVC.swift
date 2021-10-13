//
//  HomeVC.swift
//  HSMaster
//
//  Created by Davide Ruisi on 30/09/21.
//

import Tempura

/// The ViewController managing `HomeView`.
final class HomeVC: ViewController<HomeView> {
  override func setupInteraction() {
    rootView.didReachSkeletonCell = { [weak self] in
      self?.dispatch(Logic.Home.GetArticles())
    }
  }
}
