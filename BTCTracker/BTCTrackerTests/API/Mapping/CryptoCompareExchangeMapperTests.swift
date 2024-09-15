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
        let samples = [199, 201, 250, 299, 300, 400, 500]
        try samples.forEach { code in
            XCTAssertThrowsError(try CryptoCompareExchangeMapper.map(makeExchangeJSON().data, from: anyHTTPURLResponse(code: code))) { error in
                XCTAssertEqual(error as? CryptoCompareExchangeMapper.Error, .badRequest)
            }
        }
    }

    func test_map_with200ResponseCodeAndValidData_deliversMappedValue() throws {
        let json = makeExchangeJSON()

        let result = try CryptoCompareExchangeMapper.map(json.data, from: anyHTTPURLResponse(code: 200))

        XCTAssertEqual(result, json.model)
    }

    // MARK: - Helpers
    private func makeExchangeJSON(_ from: String = "BTC", _ to: String = "USDT", _ price: Double = 200.0) -> (model: Exchange, data: Data) {
        let item = Exchange(symbol: from + to, rate: price)
        let raw: [String: Any] = [ "FROMSYMBOL": from, "TOSYMBOL": to, "PRICE": price ]
        let jsonData: [String : Any] = [ "RAW": raw ]
        return (item, try! JSONSerialization.data(withJSONObject: jsonData))
    }

}
