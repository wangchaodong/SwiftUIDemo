//
//  ContentView.swift
//  Counter
//
//  Created by s1mple wang on 2022/7/11.
//

import SwiftUI
import ComposableArchitecture

struct Counter: Equatable, Identifiable {
    var count: Int = 0
    var secret = Int.random(in: -100...100)

    var id: UUID = UUID()

}
extension Counter {
    var countFloat: Float {
        get { Float(count) }
        set { count = Int(newValue) }
    }

    var countString: String {
        get {
            String(count)
        }
        set {
            count = Int(newValue) ?? count
        }
    }
}
extension Counter {
    enum CheckResult {
        case lower, higher, equal
    }
    var checkResult: CheckResult {
        if count > secret { return .higher }
        if count < secret { return .lower }
        return .equal
    }
}

enum CounterAction {
    case increment
    case decrement
    case reset
    case setCount(String)
    case slidingCount(Float)
    case playNext
}

struct CounterEnvironment {
    var generateRandom: (ClosedRange<Int>) -> Int
    var uuid: () -> UUID

    static let live = CounterEnvironment(generateRandom: Int.random, uuid: UUID.init)
}

// 2
let counterReducer = Reducer<Counter, CounterAction, CounterEnvironment> {
    state, action, environment in
    switch action {
    case .increment:
        // 3
        state.count += 1
        return .none
    case .decrement:
        // 3
        state.count -= 1
        return .none
    case .reset:
        state.count = 0
        return .none
    case .setCount(let text):
//        if let count = Int(text) {
//            state.count = count
//        }
        state.countString = text
        return .none
    case .playNext:
        state.count = 0
        state.secret = environment.generateRandom(-100 ... 100)
        state.id = environment.uuid()
        return .none
    case .slidingCount(let value):
        state.countFloat = value
        return .none
    }
}.debug()


struct ContentView: View {
    let store: Store<Counter, CounterAction>

    var body: some View {
        WithViewStore(store) { viewStore in
            VStack(spacing: 30) {
                TimelineView(.periodic(from: Date.now, by: 1.0)) { context in
                    Text(context.date.description)
                        .font(.title)
                }
                checkLabel(with: viewStore.checkResult)
                    .font(.title)
                HStack(spacing: 20) {
                    // 1
                    Button("-") { viewStore.send(.decrement) }
                    
//                    Text("\(viewStore.count)")
//                        .foregroundColor(colorOfCount(viewStore.count))
                    TextField("\(viewStore.count)",
                              text: viewStore.binding(
//                                get: { String($0.count) },
//                                send: { CounterAction.setCount($0)}
                                get: \.countString,
                                send: CounterAction.setCount
                              )
                    )
                    .frame(minWidth: 60.0)
                    .multilineTextAlignment(.center)
                    .foregroundColor(colorOfCount(viewStore.count))

                    Button("+") { viewStore.send(.increment) }
                }
                .font(.title)
                .padding()

                Slider(value: viewStore.binding(get: \.countFloat, send: CounterAction.slidingCount), in: -100...100)

                Button("Reset") {
                    viewStore.send(.reset)
                }
                Button("Next") { viewStore.send(.playNext) }

            }
        }
    }
    func colorOfCount(_ value: Int) -> Color? {
        if value == 0 { return nil }
        return value < 0 ? .red : .green
    }

    func checkLabel(with checkResult: Counter.CheckResult) -> some View {
        switch checkResult {
        case .lower:
            return Label("Lower", systemImage: "lessthan.circle")
                .foregroundColor(.red)
        case .higher:
            return Label("Higher", systemImage: "greaterthan.circle")
                .foregroundColor(.red)
        case .equal:
            return Label("Correct", systemImage: "checkmark.circle")
                .foregroundColor(.green)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(store: Store(initialState: Counter(),
                                 reducer: counterReducer,
                                 environment: .live)
        )
    }
}
