//
//  BinanceExchangeMapperTests.swift
//  BTCTrackerTests
//
//  Created by Jonathan Denney on 9/10/24.
//

import XCTest
import BTCTracker

final class CryptoCompareExchangeMapperTests: XCTestCase {

    func test_map_withInvalidJSON_throwsError() {
        let data = Data("invalid json".utf8)

        XCTAssertThrowsError(try CryptoCompareExchangeMapper.map(data, from: anyHTTPURLResponse()))
    }

    func test_map_withMalformedJSON_throwsError() {
        let data = Data("{ \"ticker\": \"BTCUSDT\" }".utf8)

        XCTAssertThrowsError(try CryptoCompareExchangeMapper.map(data, from: anyHTTPURLResponse()))
    }

    func test_map_withNon200ResponseCodeAndValidData_throwsError() throws {
        let data = Data("{ \"RAW\" : { \"FROMSYMBOL\": \"BTC\", \"TOSYMBOL\": \"USDT\", \"PRICE\": 200.0 } }".utf8)

        let samples = [199, 201, 250, 299, 300, 400, 500]
        try samples.forEach { code in
            XCTAssertThrowsError(try CryptoCompareExchangeMapper.map(data, from: anyHTTPURLResponse(code: code)))
        }
    }

    func test_map_with200ResponseCodeAndValidData_throwsBadRequestError() {
        let data = Data("{ \"RAW\" : { \"FROMSYMBOL\": \"BTC\", \"TOSYMBOL\": \"USDT\", \"PRICE\": 200.0 } }".utf8)

        let result = Result { try CryptoCompareExchangeMapper.map(data, from: anyHTTPURLResponse()) }

        switch result {
        case .success(let mapped):
            XCTAssertEqual(mapped.symbol, "BTCUSDT")
            XCTAssertEqual(mapped.rate, 200.0)
        default:
            XCTFail("Expected success, got \(result) instead")
        }
    }

    // MARK: - Helpers
    private func anyHTTPURLResponse(code: Int = 200) -> HTTPURLResponse {
        let url = URL(string: "http://any-url.com")!
        return HTTPURLResponse(url: url, statusCode: code, httpVersion: nil, headerFields: nil)!
    }

}
