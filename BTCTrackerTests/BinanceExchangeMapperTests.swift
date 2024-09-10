//
//  BinanceExchangeMapperTests.swift
//  BTCTrackerTests
//
//  Created by Jonathan Denney on 9/10/24.
//

import XCTest

final class BinanceExchangeMapper {
    enum Error: Swift.Error {
        case invalidData
    }

    static func map(_ data: Data, from response: HTTPURLResponse) throws {
        throw Error.invalidData
    }
}

final class BinanceExchangeMapperTests: XCTestCase {

    func test_map_withInvalidJSON_throwsError() {
        let data = Data("invalid json".utf8)

        XCTAssertThrowsError(try BinanceExchangeMapper.map(data, from: anyHTTPURLResponse()))
    }

    func test_map_withMalformedJSON_throwsError() {
        let data = Data("{ \"ticker\": \"BTCUSDT\" }".utf8)

        XCTAssertThrowsError(try BinanceExchangeMapper.map(data, from: anyHTTPURLResponse()))
    }

    // MARK: - Helpers
    private func anyHTTPURLResponse() -> HTTPURLResponse {
        let url = URL(string: "http://any-url.com")!
        return HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
    }

}
