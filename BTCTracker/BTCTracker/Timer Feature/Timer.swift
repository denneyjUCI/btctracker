//
//  Timer.swift
//  BTCTracker
//
//  Created by Jonathan Denney on 9/17/24.
//

import Foundation

public protocol TimerTask {
    func cancel()
}

public protocol Timer {
    func start(tick: @escaping () -> Void) -> TimerTask
}
