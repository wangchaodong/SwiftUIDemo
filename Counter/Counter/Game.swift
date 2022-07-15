//
//  Game.swift
//  Counter
//
//  Created by s1mple wang on 2022/7/11.
//

import Foundation
import SwiftUI
import ComposableArchitecture

let resultListStateTag = UUID()

struct GameState: Equatable {
    var counter: Counter = .init()
    var timer: TimerState = .init()
//    var results: [GameResult] = []
    var results = IdentifiedArrayOf<GameResult>()
    var lastTimestamp = 0.0

    var resultsListState: Identified<UUID, GameResultListState>?
}

enum GameAction {
    case counter(CounterAction)
    case timer(TimerAction)
    case listResult(GameResultListAction)
    case setNavigation(UUID?)
}

struct GameEnvironment {
    var generateRandom: (ClosedRange<Int>) -> Int
    var uuid: () -> UUID
    var date: () -> Date
    var mainQueue: AnySchedulerOf<DispatchQueue>

    static let live = GameEnvironment(
        generateRandom: Int.random,
        uuid: UUID.init,
        date: Date.init,
        mainQueue: .main
    )
}

let gameReducer = Reducer<GameState, GameAction, GameEnvironment>.combine(
    Reducer.init { state, action, environment in
        switch action {
        case .counter(.playNext):
//            let result = GameResult(secret: state.counter.secret, guess: state.counter.count, timeSpent: state.timer.duration - state.lastTimestamp)
            let result = GameResult(timeSpent: state.timer.duration - state.lastTimestamp, counter: state.counter)
            state.results.append(result)
            state.lastTimestamp = state.timer.duration
            return .none
        case .setNavigation(.none):
            state.results = state.resultsListState?.value ?? []
            state.resultsListState = nil
            return .none
        case .setNavigation(.some(let uuid)):
            state.resultsListState = .init(state.results, id: uuid)
            return .none
        default:
            return .none
        }
    },
    counterReducer.pullback(
        state: \.counter,
        action: /GameAction.counter,
        environment: { .init(generateRandom: $0.generateRandom, uuid: $0.uuid) }
    ),
    timerReducer.pullback(
        state: \.timer,
        action: /GameAction.timer,
        environment: { .init(date: $0.date, mainQueue: $0.mainQueue) }
    ),
//    gameResultListReducer.pullback(
//        state: \.results,
//        action: /GameAction.listResult,
//        environment: { _ in .init() })
    gameResultListReducer.pullback(
        state: \Identified.value, action: .self, environment: { $0 }
    )
    .optional()
    .pullback(
        state: \.resultsListState, action: /GameAction.listResult, environment: { _ in .init() }
    )
).debug()

struct GameView: View {
    let store: Store<GameState, GameAction>

    var body: some View {
//        WithViewStore(store.stateless) { viewStore in
//            VStack(spacing: 40) {
//                TimerLabelView(store: store.scope(state: \.timer, action: GameAction.timer))
//                ContentView(store: store.scope(state: \.counter, action: GameAction.counter))
//            }
//            .padding()
//            .onAppear {
//                viewStore.send(.timer(.start))
//            }
//        }

        WithViewStore(store.scope(state: \.results)) { viewStore in
            VStack {
                TimerLabelView(store: store.scope(state: \.timer, action: GameAction.timer))
                ContentView(store: store.scope(state: \.counter, action: GameAction.counter))

                Text("Result: \(viewStore.state.elements.filter(\.correct).count)/\(viewStore.state.elements.count) correct")
                    .font(.title)
                    .foregroundColor(.purple)
                Color.clear
                    .frame(width: 0, height: 0)
                    .onAppear { viewStore.send(.timer(.start)) }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink("Detail") {
                    GameResultListView(store: store.scope(state: \.results, action: GameAction.listResult))
                }
//                WithViewStore(store) { viewStore in
//                    NavigationLink(
//                        tag: resultListStateTag,
//                        selection: viewStore.binding(get: \.resultsListState?.id, send: GameAction.setNavigation),
//                        destination: {
//                            IfLetStore<Any, GameResultListAction, GameResultListView?>(
//                                store.scope(state: \.resultsListState?.value, action: GameAction.listResult)
//                            )
//                        }, label: {
//                            Text("To Detail")
//                        }
//                    )
//                }
            }
        }
    }
}

struct GameResult: Equatable, Identifiable {
//    let secret: Int
//    let guess: Int
    let timeSpent: TimeInterval

    var correct: Bool {
        counter.secret == counter.count
    }
    let counter: Counter

    var id: UUID { counter.id }
}
