//
//  AppDelegate.swift
//  HSMaster
//
//  Created by Davide Ruisi on 15/09/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?

  func application(
    _ application: UIApplication,
    // swiftlint:disable:next discouraged_optional_collection
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let window = UIWindow()
    let vc = ViewController()
    window.rootViewController = vc
    self.window = window

    window.makeKeyAndVisible()

    return true
  }
}
