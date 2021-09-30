//
//  TabBarController.swift
//  HSMaster
//
//  Created by Davide Ruisi on 28/09/21.
//

import Katana
import UIKit

/// The Controller managing the main tab-bar of the app.
final class TabBarController: UITabBarController {

  // MARK: Properties

  /// The Katana store of the app.
  var store: Store<AppState, AppDependencies>

  // MARK: Init

  init(store: Store<AppState, AppDependencies>) {
    self.store = store
    super.init(nibName: nil, bundle: nil)

    setup()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Setup

  func setup() {
    viewControllers = Tab.allCases.map { $0.viewController(store: store) }
  }
}
