//
//  AppNavigation.swift
//  HSMaster
//
//  Created by Davide Ruisi on 28/09/21.
//

import SafariServices
import Tempura

/// The list of `Routable` screens.
enum Screen: String {
  /// The home tab.
  case home

  /// The card detail view.
  case cardDetail

  /// The card search tab.
  case cardSearch

  /// Open a URL link in a Safari Web-View.
  case safariWebView

  /// The main tab-bar of the app.
  case tabBar
}

extension TabBarController: RoutableWithConfiguration {
  var routeIdentifier: RouteElementIdentifier {
    Screen.tabBar.rawValue
  }

  var navigationConfiguration: [NavigationRequest: NavigationInstruction] {
    [:]
  }
}

extension HomeVC: RoutableWithConfiguration {
  var routeIdentifier: RouteElementIdentifier {
    Screen.home.rawValue
  }

  var navigationConfiguration: [NavigationRequest: NavigationInstruction] {
    [
      .show(Screen.safariWebView): .presentModally { context in
        guard let url = context as? URL else {
          AppLogger.critical("Wrong context: expected \(URL.self), received \(String(describing: context))")
          fatalError()
        }

        return SFSafariViewController(url: url)
      }
    ]
  }
}

extension CardSearchVC: RoutableWithConfiguration {
  var routeIdentifier: RouteElementIdentifier {
    Screen.cardSearch.rawValue
  }

  var navigationConfiguration: [NavigationRequest: NavigationInstruction] {
    [
      .show(Screen.cardDetail): .presentModally { [store] context in
        guard let localState = context as? CardDetailLS else {
          AppLogger.critical("Wrong context: expected \(CardDetailLS.self), received \(String(describing: context))")
          fatalError()
        }

        return UINavigationController(rootViewController: CardDetailVC(store: store, localState: localState))
      }
    ]
  }
}

extension CardDetailVC: RoutableWithConfiguration {
  var routeIdentifier: RouteElementIdentifier {
    Screen.cardDetail.rawValue
  }

  var navigationConfiguration: [NavigationRequest: NavigationInstruction] {
    [.hide(Screen.cardDetail): .dismissModally(behaviour: .hard)]
  }
}
