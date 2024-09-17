//
//  BTCTrackeriOSTests.swift
//  BTCTrackeriOSTests
//
//  Created by Jonathan Denney on 9/16/24.
//

import XCTest
@testable import BTCTrackeriOS

class ExchangeViewController: UIViewController {

    let errorLabel = UILabel()

    private var timer: BTCTrackeriOSTests.TimerSpy!
    convenience init(timer: BTCTrackeriOSTests.TimerSpy) {
        self.init()

        self.timer = timer
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        timer.start()
        errorLabel.text = "Failed to update value."
    }
}

final class BTCTrackeriOSTests: XCTestCase {

    func test_init_doesNotRequestExchangeRate() {
        let (_, timer) = makeSUT()

        XCTAssertEqual(timer.startCount, 0)
    }

    func test_viewDidLoad_requestsExchangeRates() {
        let (sut, timer) = makeSUT()

        sut.loadViewIfNeeded()

        XCTAssertEqual(timer.startCount, 1)
    }

    func test_viewDidLoad_onError_rendersErrorMessage() {
        let (sut, timer) = makeSUT()
        sut.loadViewIfNeeded()

        timer.completeLoadWithError()

        XCTAssertEqual(sut.errorLabel.text, "Failed to update value.")
    }

    // MARK: - Helpers
    func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: ExchangeViewController, timer: TimerSpy) {
        let timer = TimerSpy()
        let sut = ExchangeViewController(timer: timer)
        trackForMemoryLeaks(timer, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, timer)
    }


    class TimerSpy {
        var startCount = 0

        func start() {
            startCount += 1
        }

        func completeLoadWithError() {

        }
    }

}
