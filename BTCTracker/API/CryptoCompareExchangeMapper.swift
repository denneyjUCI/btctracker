//
//  BinanceExchangeMapper.swift
//  BTCTracker
//
//  Created by Jonathan Denney on 9/11/24.
//

import Foundation

public final class CryptoCompareExchangeMapper {
    public enum Error: Swift.Error {
        case invalidData
        case badRequest
        case rateLimit
    }

    public static func map(_ data: Data, from response: HTTPURLResponse) throws -> Exchange {
        if response.statusCode == 429 {
            throw Error .rateLimit
        }

        if response.statusCode != 200 {
            throw Error.badRequest
        }

        guard let mapped = try? JSONDecoder().decode(Root.self, from: data) else {
            throw Error.invalidData
        }

        return mapped.exchange
    }

    private struct Root: Decodable {
        private let RAW: Raw

        private struct Raw: Decodable {
            let FROMSYMBOL: String
            let TOSYMBOL: String
            let PRICE: Double
        }

        var exchange: Exchange {
            Exchange(symbol: RAW.FROMSYMBOL+RAW.TOSYMBOL, rate: RAW.PRICE)
        }
    }
}
