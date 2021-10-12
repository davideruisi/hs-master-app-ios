//
//  AppDispatchable.swift
//  HSMaster
//
//  Created by Davide Ruisi on 13/10/21.
//

import Katana

protocol AppStateUpdater: StateUpdater where StateType == AppState {}

protocol AppSideEffect: SideEffect where StateType == AppState, Dependencies == AppDependencies {}
