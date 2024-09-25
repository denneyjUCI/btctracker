//
//  FoundationTimer.swift
//  BTCTracker
//
//  Created by Jonathan Denney on 9/17/24.
//

import Foundation

public final class FoundationTimer {
    private let hertz: Int
    private var timer: Foundation.Timer?
    private let stopped: () -> Void

    public init(hertz: Int = 1, stopped: @escaping () -> Void) {
        self.hertz = hertz
        self.stopped = stopped
    }

    public func start(tick: @escaping () -> Void) {
        let timer = Foundation.Timer.scheduledTimer(withTimeInterval: 1 / Double(hertz), repeats: true, block: { [tick] _ in
            tick()
        })
        RunLoop.main.add(timer, forMode: .common)
        self.timer = timer
        tick()
    }

    public func stop() {
        if let timer = timer {
            timer.invalidate()
            self.timer = nil
            stopped()
        }
    }

    deinit {
        stop()
    }
}
