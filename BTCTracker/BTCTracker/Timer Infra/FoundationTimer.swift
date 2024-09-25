//
//  FoundationTimer.swift
//  BTCTracker
//
//  Created by Jonathan Denney on 9/17/24.
//

import Foundation

public final class FoundationTimer: Timer {
    private let hertz: Int
    private var timer: Foundation.Timer?

    public init(hertz: Int = 1) {
        self.hertz = hertz
    }

    private class TimerTaskWrapper: TimerTask {
        let callback: () -> Void
        init(callback: @escaping () -> Void) {
            self.callback = callback
        }

        func cancel() {
            callback()
        }
    }

    public func start(tick: @escaping () -> Void) -> TimerTask {
        let timer = Foundation.Timer.scheduledTimer(withTimeInterval: 1 / Double(hertz), repeats: true, block: { [tick] _ in
            tick()
        })
        RunLoop.main.add(timer, forMode: .common)
        self.timer = timer
        tick()

        return TimerTaskWrapper(callback: stop)
    }

    public func stop() {
        if let timer = timer {
            timer.invalidate()
            self.timer = nil
        }
    }

    deinit {
        stop()
    }
}
