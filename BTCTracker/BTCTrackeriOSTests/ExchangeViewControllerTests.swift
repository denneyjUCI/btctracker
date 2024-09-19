//
//  ExchangeViewControllerTests.swift
//  BTCTrackeriOSTests
//
//  Created by Jonathan Denney on 9/16/24.
//

import XCTest
import BTCTracker
import BTCTrackeriOS

final class ExchangeViewControllerTests: XCTestCase {

    func test_init_doesNotRequestExchangeRate() {
        let (_, timer) = makeSUT()

        XCTAssertEqual(timer.startCount, 0)
    }

    func test_viewDidLoad_requestsExchangeRates() {
        let (sut, timer) = makeSUT()

        sut.loadViewIfNeeded()

        XCTAssertEqual(timer.startCount, 1)
    }

    func test_viewDidLoad_rendersLastSuccessfulResponse() {
        let (sut, _) = makeSUT()
        sut.loadViewIfNeeded()

        sut.display(error: "error message")
        XCTAssertEqual(sut.errorLabel.text, "error message")
        XCTAssertNil(sut.valueLabel.text, "Expected no value on first error")

        sut.display(Exchange(symbol: "a_symbol", rate: 100))
        XCTAssertNil(sut.errorLabel.text, "Expected no error after success")
        XCTAssertEqual(sut.valueLabel.text, "100.0", "Expected value after success")
        XCTAssertEqual(sut.symbolLabel.text, "a_symbol", "Expected a symbol")

        sut.display(error: "error message")
        XCTAssertEqual(sut.errorLabel.text, "error message")
        XCTAssertEqual(sut.valueLabel.text, "100.0", "Expected value to still be shown after error")
        XCTAssertEqual(sut.symbolLabel.text, "a_symbol", "Expected a symbol to still be shown after error")

        sut.display(Exchange(symbol: "new_symbol", rate: 200))
        XCTAssertNil(sut.errorLabel.text, "Expected no error after success")
        XCTAssertEqual(sut.valueLabel.text, "200.0", "Expected new value after success")
        XCTAssertEqual(sut.symbolLabel.text, "new_symbol", "Expected new symbol")
    }

    // MARK: - Helpers
    func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: ExchangeViewController, timer: TimerSpy) {
        let timer = TimerSpy()
        let sut = ExchangeViewController(onViewLoad: timer.start)
        trackForMemoryLeaks(timer, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, timer)
    }

    class TimerSpy {
        var startCount = 0

        func start() {
            startCount += 1
        }
    }

}
