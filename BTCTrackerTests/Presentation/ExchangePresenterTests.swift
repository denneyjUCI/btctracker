//
//  ExchangePresenterTests.swift
//  BTCTrackerTests
//
//  Created by Jonathan Denney on 9/14/24.
//

import XCTest

final class ExchangePresenter {
    typealias View = ExchangePresenterTests.ViewSpy

    private let view: View
    init(view: View) {
        self.view = view
    }

    func didStartLoading() {
        view.display(isLoading: true)
    }
}

final class ExchangePresenterTests: XCTestCase {

    func test_init_doesNotSendMessagesToView() {
        let view = ViewSpy()

        let _ = ExchangePresenter(view: view)

        XCTAssertEqual(view.messageCount, 0)
    }

    func test_startLoading_displaysStartsLoadingMessage() {
        let view = ViewSpy()
        let sut = ExchangePresenter(view: view)

        sut.didStartLoading()

        XCTAssertEqual(view.messages, [ .display(isLoading: true) ])
    }

    // MARK: - Helpers
    final class ViewSpy {
        var messageCount = 0

        private(set) var messages = [Message]()
        enum Message: Equatable {
            case display(isLoading: Bool)
        }

        func display(isLoading: Bool) {
            messages.append(.display(isLoading: isLoading))
        }
    }

}
