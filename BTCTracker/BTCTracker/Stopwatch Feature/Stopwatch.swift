//
//  Timer.swift
//  BTCTracker
//
//  Created by Jonathan Denney on 9/17/24.
//

import Foundation

public protocol StopwatchTask {
    func cancel()
}

public protocol Stopwatch {
    func start(tick: @escaping () -> Void) -> StopwatchTask
}
