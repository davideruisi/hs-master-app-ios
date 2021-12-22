//
//  AppDelegate.swift
//  HSMaster
//
//  Created by Davide Ruisi on 15/09/21.
//

import Katana
import Kingfisher
import PinLayout
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
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Create the window.
    let window = UIWindow(frame: UIScreen.main.bounds)
    self.window = window
    window.makeKeyAndVisible()

    // Initialize the store.
    self.store = Store<AppState, AppDependencies>(interceptors: [], stateInitializer: AppState.init)

    // Start the navigation.
    self.store?.dependencies?.navigator.start(using: self, in: window, at: Screen.tabBar)

    // Execute AppSetup logic in background.
    // This logic is non-blocking and can be executed after the start of the app navigation.
    self.store?.dispatch(Logic.AppSetup.Start())

    return true
  }
}

// MARK: - Tempura RootInstaller

extension AppDelegate: RootInstaller {
  func installRoot(identifier: RouteElementIdentifier, context: Any?, completion: @escaping Navigator.Completion) -> Bool {
    guard
      let store = store,
      let rootScreen = Screen(rawValue: identifier)
    else {
      return false
    }

    switch rootScreen {
    case .tabBar:
      let tabBarController = TabBarController(store: store)
      self.window?.rootViewController = tabBarController

      completion()

      return true

    default:
      AppLogger.critical("Cannot install root with identifier \(identifier)")
      fatalError()
    }
  }
}
