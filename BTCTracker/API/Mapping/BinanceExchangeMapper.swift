//
//  BinanceExchangeMapper.swift
//  BTCTracker
//
//  Created by Jonathan Denney on 9/11/24.
//

import Foundation

public final class BinanceExchangeMapper {
    public enum Error: Swift.Error {
        case invalidData
        case badRequest
        case rateLimit
    }

    public static func map(_ data: Data, from response: HTTPURLResponse) throws -> Exchange {
        if response.statusCode == 429 {
            throw Error .rateLimit
        }

        if [400, 403, 409, 418].contains(response.statusCode) {
            throw Error.badRequest
        }

        guard let mapped = try? JSONDecoder().decode(Root.self, from: data) else {
            throw Error.invalidData
        }

        return mapped.exchange
    }

    private struct Root: Decodable {
        let symbol: String
        let price: Double

        var exchange: Exchange {
            Exchange(symbol: symbol, rate: price)
        }
    }
}
