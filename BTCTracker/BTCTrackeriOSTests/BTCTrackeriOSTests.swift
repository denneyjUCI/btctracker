//
//  BTCTrackeriOSTests.swift
//  BTCTrackeriOSTests
//
//  Created by Jonathan Denney on 9/16/24.
//

import XCTest
@testable import BTCTrackeriOS

class ExchangeViewController {

}

final class BTCTrackeriOSTests: XCTestCase {

    func test_init_doesNotRequestExchangeRate() {
        let loader = LoaderSpy()
        let _ = ExchangeViewController()

        XCTAssertEqual(loader.loadCount, 0)
    }

    // MARK: - Helpers
    private class LoaderSpy {
        let loadCount = 0
    }

}
