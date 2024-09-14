//
//  ExchangePresenterTests.swift
//  BTCTrackerTests
//
//  Created by Jonathan Denney on 9/14/24.
//

import XCTest

final class ExchangePresenter {
    typealias View = ExchangePresenterTests.ViewSpy

    init(view: View) {

    }
}

final class ExchangePresenterTests: XCTestCase {

    func test_init_doesNotSendMessagesToView() {
        let view = ViewSpy()

        let _ = ExchangePresenter(view: view)

        XCTAssertEqual(view.messageCount, 0)
    }

    // MARK: - Helpers
    final class ViewSpy {
        var messageCount = 0
    }

}
