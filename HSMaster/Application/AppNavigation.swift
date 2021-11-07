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

  /// Open a URL link in a Safari Web-View.
  case safariWebView

  /// The main tab-bar of the app.
  case tabBar
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
