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
        return exchange.symbol + " exchange rate is " + String(format: "%0.2f", exchange.rate)
    }

    public var symbol: String {
        exchange.symbol
    }

    public var price: String {
        String(format: "%0.2f", exchange.rate)
    }
}
