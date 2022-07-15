//
//  CounterTests.swift
//  CounterTests
//
//  Created by s1mple wang on 2022/7/11.
//

import XCTest
@testable import Counter
import ComposableArchitecture

class CounterTests: XCTestCase {

    var store: TestStore<Counter, Counter, CounterAction, CounterAction, CounterEnvironment>!

    override func setUp() {
        store = TestStore(
            initialState: Counter(count: Int.random(in: -100...100)),
            reducer: counterReducer,
            environment: .test
        )
    }

    func testCounterIncrement() throws {
        store.send(.increment) { state in
            state.count += 1
        }
    }
    func testCounterDecrement() throws {
        store.send(.decrement) { state in
            state.count -= 1
        }
    }
    func testCounterReset() throws {
        store.send(.reset) { state in
            state.count = 0
        }
    }
    func testCounterPlaynext() throws {
        store.send(.playNext) { state in
            state = Counter(count: 0, secret: 5, id: .dummy)
        }
    }
    func testSliderSetCount() {
        store.send(.slidingCount(72.3)) { state in
            state.count = 72
        }
    }

}

extension UUID {
    static let dummy = UUID(uuidString: "ABABABAB-CDCD-EFEF-ABAB-CDCDCDCDCDCD")!
}

extension CounterEnvironment {
    static let test = CounterEnvironment(
        generateRandom: { _ in 5 },
        uuid: { .dummy }
    )
}
