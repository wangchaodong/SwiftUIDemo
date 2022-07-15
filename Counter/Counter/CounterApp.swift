//
//  CounterApp.swift
//  Counter
//
//  Created by s1mple wang on 2022/7/11.
//

import SwiftUI
import ComposableArchitecture

@main
struct CounterApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                GameView(store: Store(
                    initialState: GameState(),
                    reducer: gameReducer,
                    environment: GameEnvironment.live)
                )
            }
        }
    }
}
