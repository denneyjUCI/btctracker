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

    static func map(_ data: Data) throws {
        throw Error.invalidData
    }
}

final class BinanceExchangeMapperTests: XCTestCase {

    func test_map_withInvalidJSON_throwsError() {
        let data = Data("invalid json".utf8)

        XCTAssertThrowsError(try BinanceExchangeMapper.map(data))
    }

}
