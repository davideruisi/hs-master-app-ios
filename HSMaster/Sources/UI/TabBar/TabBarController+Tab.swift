//
//  TabBarController+Tab.swift
//  HSMaster
//
//  Created by Davide Ruisi on 29/09/21.
//

import Katana
import UIKit

extension TabBarController {
  /// An enum containing each tab of the main tab-bar.
  enum Tab: CaseIterable {
    /// The home tab where the user can see news and articles.
    case home

    /// The meta tab containing the best decks.
    case meta

    /// The card search tab where the user can search cards.
    case cardSearch
  }
}

// MARK: - Helpers

extension TabBarController.Tab {
  /// The item's image when it is selected.
  var selectedImage: UIImage? {
    switch self {
    case .home:
      return UIImage(systemName: "newspaper.fill")

    case .meta:
      return UIImage(systemName: "crown.fill")

    case .cardSearch:
      return UIImage(systemName: "square.stack.fill")
    }
  }

  /// The item's image when it is not selected.
  var deselectedImage: UIImage? {
    switch self {
    case .home:
      return UIImage(systemName: "newspaper")

    case .meta:
      return UIImage(systemName: "crown")

    case .cardSearch:
      return UIImage(systemName: "square.stack")
    }
  }

  /// The item's title.
  var title: String {
    switch self {
    case .home:
      return HSMasterStrings.HomeTab.title

    case .meta:
      return HSMasterStrings.MetaTab.title

    case .cardSearch:
      return HSMasterStrings.CardSearchTab.title
    }
  }

  /// Creates and returns the UIViewController related to this tab.
  /// - Parameter store: The `Store` needed to initialize the ViewController.
  /// - Returns: The UIViewController related to this tab,
  func viewController(store: Store<AppState, AppDependencies>) -> UIViewController {
    switch self {
    case .home:
      let homeViewController = HomeVC(store: store)

      homeViewController.tabBarItem = UITabBarItem(title: title, image: deselectedImage, selectedImage: selectedImage)

      homeViewController.navigationItem.title = title

      let navigationController = UINavigationController(rootViewController: homeViewController)
      navigationController.navigationBar.prefersLargeTitles = true

      return navigationController

    case .meta:
      let metaViewController = MetaVC(store: store)

      metaViewController.tabBarItem = UITabBarItem(title: title, image: deselectedImage, selectedImage: selectedImage)

      metaViewController.navigationItem.title = title

      let navigationController = UINavigationController(rootViewController: metaViewController)
      navigationController.navigationBar.prefersLargeTitles = true

      return navigationController

    case .cardSearch:
      let cardSearchViewController = CardSearchVC(store: store)

      cardSearchViewController.tabBarItem = UITabBarItem(title: title, image: deselectedImage, selectedImage: selectedImage)

      cardSearchViewController.navigationItem.title = title

      let navigationController = UINavigationController(rootViewController: cardSearchViewController)
      navigationController.navigationBar.prefersLargeTitles = true

      return navigationController
    }
  }
}
