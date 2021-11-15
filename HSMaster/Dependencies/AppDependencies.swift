//
//  AppDependencies.swift
//  HSMaster
//
//  Created by Davide Ruisi on 22/09/21.
//

import Katana
import Tempura

/// The container for the dependencies of the App.
final class AppDependencies: SideEffectDependencyContainer, NavigationProvider {

  // MARK: Properties

  /// The dispatch function that can be used to dispatch SideEffects and State Updater.
  let dispatch: AnyDispatch

  /// A closure that returns the most updated version of the state.
  let getState: GetState

  /// An object that helps to manage the navigation with Tempura.
  let navigator: Navigator

  /// An object that fetch app contents from Contentful.
  let contentfulManager: ContentfulManager

  /// The manager of the app network requests.
  let networkManager: NetworkManager

  // MARK: Init

  init(dispatch: @escaping AnyDispatch, getState: @escaping GetState) {
    self.dispatch = dispatch
    self.getState = getState
    self.navigator = Navigator()
    self.contentfulManager = ContentfulManager()
    self.networkManager = NetworkManager()
  }
}
