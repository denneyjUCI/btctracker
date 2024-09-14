//
//  ExchangeViewModel.swift
//  BTCTracker
//
//  Created by Jonathan Denney on 9/14/24.
//

import Foundation

public struct ExchangeViewModel: Equatable, Hashable {

    private let exchange: Exchange

    public init(exchange: Exchange) {
        self.exchange = exchange
    }

    public var message: String {
        return exchange.symbol + " is worth " + String(format: "$%0.2f", exchange.rate)
    }

}
