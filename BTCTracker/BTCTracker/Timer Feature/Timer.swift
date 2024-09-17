//
//  Timer.swift
//  BTCTracker
//
//  Created by Jonathan Denney on 9/17/24.
//

import Foundation

public protocol Timer {
    func start(tick: () -> Void)
}
