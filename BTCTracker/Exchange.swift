//
//  Exchange.swift
//  BTCTracker
//
//  Created by Jonathan Denney on 9/10/24.
//

import Foundation

public struct Exchange {
    public let symbol: String
    public let rate: Double

    public init(symbol: String, rate: Double) {
        self.symbol = symbol
        self.rate = rate
    }
}
