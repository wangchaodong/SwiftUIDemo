//
//  TimerTest.swift
//  CounterTests
//
//  Created by s1mple wang on 2022/7/11.
//

import XCTest
@testable import Counter
import ComposableArchitecture

class TimerTest: XCTestCase {
    let scheduler = DispatchQueue.test


    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testTimerupdate() throws {
        let timerStore = TestStore(initialState: TimerState(),
                                   reducer: timerReducer,
                                   environment: TimerEnvironment(date: { Date.init(timeIntervalSince1970: 100) }, mainQueue: scheduler.eraseToAnyScheduler()))
        timerStore.send(.start) { timerState in
            timerState.started = Date(timeIntervalSince1970: 100)
        }

        scheduler.advance(by: .milliseconds(35))

        timerStore.receive(.timeUpdate) { timerState in
            timerState.duration = 0.01
        }
        timerStore.receive(.timeUpdate) { timerState in
            timerState.duration = 0.02
        }
        timerStore.receive(.timeUpdate) { timerState in
            timerState.duration = 0.03
        }
        timerStore.send(.stop)
    }

}
