//
//  AppDelegate.swift
//  HSMaster
//
//  Created by Davide Ruisi on 15/09/21.
//

import Katana
import Tempura
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

  // MARK: Properties

  var window: UIWindow?

  var store: Store<AppState, AppDependencies>?
  
  // MARK: App Lifecycle

  func application(
    _ application: UIApplication,
    // swiftlint:disable:next discouraged_optional_collection
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Create the window.
    let window = UIWindow(frame: UIScreen.main.bounds)
    self.window = window
    window.makeKeyAndVisible()

    // Initialize the store.
    store = Store<AppState, AppDependencies>(interceptors: [], stateInitializer: AppState.init)

    // Start the navigation.
    store?.dependencies?.navigator.start(using: self, in: window, at: "initialScreen")

    return true
  }
}

// MARK: - Tempura RootInstaller

extension AppDelegate: RootInstaller {
  func installRoot(identifier: RouteElementIdentifier, context: Any?, completion: @escaping Navigator.Completion) -> Bool {
      if identifier == "initialScreen" {
        let vc = UIViewController()
        vc.view.backgroundColor = .green
        self.window?.rootViewController = vc

        completion()

        return true
      }

      return false
    }
}
