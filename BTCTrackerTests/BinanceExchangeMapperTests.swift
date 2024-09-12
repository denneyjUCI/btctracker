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
        let data = Data("{ \"ticker\": \"BTCUSDT\" }".utf8)

        XCTAssertThrowsError(try BinanceExchangeMapper.map(data, from: anyHTTPURLResponse()))
    }

    func test_map_with4xxResponseCodeAndValidData_throwsBadRequestError() {
        let data = Data("{ \"symbol\": \"BTCUSDT\", \"price\": 200.0 }".utf8)

        let samples = [400, 403, 409, 418]
        samples.forEach { code in
            let result = Result { try BinanceExchangeMapper.map(data, from: anyHTTPURLResponse(code: code)) }

            switch result {
            case .failure(let error as BinanceExchangeMapper.Error):
                XCTAssertEqual(error, BinanceExchangeMapper.Error.badRequest)
            default:
                XCTFail("Expected bad request error, got \(result) instead")
            }
        }
    }

    func test_map_with429ResponseCodeAndValidData_throwsBadRequestError() {
        let data = Data("{ \"symbol\": \"BTCUSDT\", \"price\": 200.0 }".utf8)

        let result = Result { try BinanceExchangeMapper.map(data, from: anyHTTPURLResponse(code: 429)) }

        switch result {
        case .failure(let error as BinanceExchangeMapper.Error):
            XCTAssertEqual(error, BinanceExchangeMapper.Error.rateLimit)
        default:
            XCTFail("Expected bad request error, got \(result) instead")
        }
    }

    func test_map_with200ResponseCodeAndValidData_throwsBadRequestError() {
        let data = Data("{ \"symbol\": \"BTCUSDT\", \"price\": 200.0 }".utf8)

        let result = Result { try BinanceExchangeMapper.map(data, from: anyHTTPURLResponse()) }

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
