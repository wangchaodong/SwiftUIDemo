//
//  TimerView.swift
//  Counter
//
//  Created by s1mple wang on 2022/7/11.
//

import Foundation
import SwiftUI
import ComposableArchitecture

struct TimerState: Equatable {
    var started: Date? = nil
    var duration: TimeInterval = 0
}

enum TimerAction {
    case start
    case stop
    case timeUpdate
}

struct TimerEnvironment {
    var date: () -> Date
    var mainQueue: AnySchedulerOf<DispatchQueue>

    static var live: TimerEnvironment {
        .init(date: Date.init, mainQueue: .main)
    }
}

let timerReducer = Reducer<TimerState, TimerAction, TimerEnvironment> {
    state, action, environment in
    struct TimerId: Hashable {

    }

    switch action {
    case .start:
        if state.started == nil {
            state.started = environment.date()
        }
        return Effect.timer(id: TimerId(),
                            every: .milliseconds(10),
                            on: environment.mainQueue)
        .map { time in
            return TimerAction.timeUpdate
        }
    case .stop:
        return .cancel(id: TimerId())
    case .timeUpdate:
        state.duration += 0.01
        return .none
    }
} // .debug()

struct TimerLabelView: View {
    let store: Store<TimerState, TimerAction>

    var body: some View {
        WithViewStore(store) { viewStore in
            VStack(alignment: .leading, spacing: 20) {
                Label(
                    viewStore.started == nil ? "-" : "\(viewStore.started!.formatted(date: .omitted, time: .standard))",
                    systemImage: "clock"
                )
                Label(
                    "\(viewStore.duration, format: .number)s",
                    systemImage: "timer"
                )
                HStack {
                    Button("Start") { viewStore.send(.start) }
                    Button("Stop") { viewStore.send(.stop) }
                }
                .padding()
            }
            .padding()
            .font(.title)
        }
    }
}

struct TimerLabelView_Preview: PreviewProvider {
    static let store = Store(initialState: TimerState(), reducer: timerReducer, environment: .live)

    static var previews: some View {
        TimerLabelView(store: store)
    }
}
