//
//  BTCTrackeriOSTests.swift
//  BTCTrackeriOSTests
//
//  Created by Jonathan Denney on 9/16/24.
//

import XCTest
@testable import BTCTrackeriOS

class ExchangeViewController: UIViewController {
    private var loader: BTCTrackeriOSTests.LoaderSpy!
    convenience init(loader: BTCTrackeriOSTests.LoaderSpy) {
        self.init()

        self.loader = loader
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        loader.load()
    }


}

final class BTCTrackeriOSTests: XCTestCase {

    func test_init_doesNotRequestExchangeRate() {
        let loader = LoaderSpy()
        let _ = ExchangeViewController()

        XCTAssertEqual(loader.loadCount, 0)
    }

    func test_viewDidLoad_requestsExchangeRates() {
        let loader = LoaderSpy()
        let sut = ExchangeViewController(loader: loader)

        sut.loadViewIfNeeded()

        XCTAssertEqual(loader.loadCount, 1)
    }

    // MARK: - Helpers
    class LoaderSpy {
        var loadCount = 0

        func load() {
            loadCount += 1
        }
    }

}
