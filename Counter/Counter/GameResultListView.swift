//
//  GameResultListView.swift
//  Counter
//
//  Created by s1mple wang on 2022/7/12.
//

import SwiftUI
import ComposableArchitecture

typealias GameResultListState = IdentifiedArrayOf<GameResult>

enum GameResultListAction {
    case remove(offset: IndexSet)
}
struct GameResultListEnvironment {}

let gameResultListReducer = Reducer<GameResultListState, GameResultListAction, GameResultListEnvironment> {
    state, action, environment in
    switch action {
    case .remove(let offset):
        state.remove(atOffsets: offset)
        return .none
    }
}

struct GameResultListView: View {
    let store: Store<GameResultListState, GameResultListAction>
    var body: some View {
        WithViewStore(store) { viewStore in
            List {
                ForEach(viewStore.state) { result in
                    HStack {
                        Image(systemName: result.correct ? "checkmark.circle" : "x.circle")
                        Text("Secret: \(result.counter.secret)")
                        Text("Answer: \(result.counter.count)")
                    }.foregroundColor(result.correct ? .green : .red)
                }
                .onDelete(perform: { viewStore.send(.remove(offset: $0))})
            }
            .toolbar {
                EditButton()
            }
        }
    }
}

struct GameResultListView_Previews: PreviewProvider {
    static var previews: some View {
        GameResultListView(
            store: .init(
                initialState: [
                    GameResult(
                        timeSpent: 100, counter: .init(
                            count: 20, secret: 20, id: .init()
                        )),
                    GameResult(
                        timeSpent: 100, counter: .init())
                ],
                reducer: gameResultListReducer,
                environment: .init()
            )
        )
    }
}
