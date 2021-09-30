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

    /// The search tab where the user can search cards.
    case search
  }
}

// MARK: - Helpers

extension TabBarController.Tab {
  /// The item's image when it is selected.
  var selectedImage: UIImage? {
    switch self {
    case .home:
      return UIImage(systemName: "doc.text.image.fill")

    case .search:
      return UIImage(systemName: "magnifyingglass.circle.fill")
    }
  }

  /// The item's image when it is not selected.
  var deselectedImage: UIImage? {
    switch self {
    case .home:
      return UIImage(systemName: "doc.text.image")

    case .search:
      return UIImage(systemName: "magnifyingglass.circle")
    }
  }

  /// The item's title.
  var title: String {
    switch self {
    case .home:
      return "News"

    case .search:
      return "Search"
    }
  }

  func viewController(store: Store<AppState, AppDependencies>) -> UIViewController {
    switch self {
    case .home:
      let homeViewController = UIViewController()
      homeViewController.tabBarItem = UITabBarItem(title: title, image: deselectedImage, selectedImage: selectedImage)
      return UINavigationController(rootViewController: homeViewController)

    case .search:
      let searchViewController = UIViewController()
      searchViewController.tabBarItem = UITabBarItem(title: title, image: deselectedImage, selectedImage: selectedImage)
      return UINavigationController(rootViewController: searchViewController)
    }
  }
}
