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
        let (_, loader) = makeSUT()

        XCTAssertEqual(loader.loadCount, 0)
    }

    func test_viewDidLoad_requestsExchangeRates() {
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()

        XCTAssertEqual(loader.loadCount, 1)
    }

    // MARK: - Helpers
    func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: ExchangeViewController, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let sut = ExchangeViewController(loader: loader)
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, loader)
    }


    class LoaderSpy {
        var loadCount = 0

        func load() {
            loadCount += 1
        }
    }

}
