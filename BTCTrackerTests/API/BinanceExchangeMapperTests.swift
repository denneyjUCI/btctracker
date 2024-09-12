//
//  BinanceExchangeMapperTests.swift
//  BTCTrackerTests
//
//  Created by Jonathan Denney on 9/10/24.
//

import XCTest
import BTCTracker

final class BinanceExchangeMapperTests: XCTestCase {

    func test_map_withInvalidJSON_throwsError() {
        let data = Data("invalid json".utf8)

        XCTAssertThrowsError(try BinanceExchangeMapper.map(data, from: anyHTTPURLResponse()))
    }

    func test_map_withMalformedJSON_throwsError() {
        let data = try! JSONSerialization.data(withJSONObject: [ "ticker": 200.0 ])

        XCTAssertThrowsError(try BinanceExchangeMapper.map(data, from: anyHTTPURLResponse()))
    }

    func test_map_with4xxResponseCodeAndValidData_throwsBadRequestError()throws  {
        let data = makeExchangeJSON().data

        let samples = [400, 403, 409, 418]
        try samples.forEach { code in
            XCTAssertThrowsError(try BinanceExchangeMapper.map(data, from: anyHTTPURLResponse(code: code))) { error in
                XCTAssertEqual(error as? BinanceExchangeMapper.Error, BinanceExchangeMapper.Error.badRequest)
            }
        }
    }

    func test_map_with429ResponseCodeAndValidData_throwsBadRequestError() {
        XCTAssertThrowsError(try BinanceExchangeMapper.map(makeExchangeJSON().data, from: anyHTTPURLResponse(code: 429))) { error in
            XCTAssertEqual(error as? BinanceExchangeMapper.Error, BinanceExchangeMapper.Error.rateLimit)
        }
    }

    func test_map_with200ResponseCodeAndValidData_throwsBadRequestError() throws {
        let json = makeExchangeJSON()

        let result = try BinanceExchangeMapper.map(json.data, from: anyHTTPURLResponse())

        XCTAssertEqual(result, json.model)
    }

    // MARK: - Helpers
    private func makeExchangeJSON(_ symbol: String = "BTCUSDT", _ price: Double = 200.0) -> (model: Exchange, data: Data) {
        let item = Exchange(symbol: symbol, rate: price)
        let jsonData: [String: Any] = [ "symbol": symbol, "price": price ]
        return (item, try! JSONSerialization.data(withJSONObject: jsonData))
    }

    private func anyHTTPURLResponse(code: Int = 200) -> HTTPURLResponse {
        let url = URL(string: "http://any-url.com")!
        return HTTPURLResponse(url: url, statusCode: code, httpVersion: nil, headerFields: nil)!
    }

}
