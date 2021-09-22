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
  var navigator: Navigator

  // MARK: Init

  init(dispatch: @escaping AnyDispatch, getState: @escaping GetState) {
    self.dispatch = dispatch
    self.getState = getState
    self.navigator = Navigator()
  }
}
