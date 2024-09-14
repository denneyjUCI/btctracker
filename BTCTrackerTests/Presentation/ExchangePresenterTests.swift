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
        let (_, view) = makeSUT()

        XCTAssertEqual(view.messages, [])
    }

    func test_startLoading_displaysStartsLoadingMessage() {
        let (sut, view) = makeSUT()

        sut.didStartLoading()

        XCTAssertEqual(view.messages, [ .display(isLoading: true) ])
    }

    // MARK: - Helpers
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: ExchangePresenter, view: ViewSpy) {
        let view = ViewSpy()
        let sut = ExchangePresenter(view: view)
        trackForMemoryLeaks(view, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, view)
    }

    final class ViewSpy {
        private(set) var messages = [Message]()
        enum Message: Equatable {
            case display(isLoading: Bool)
        }

        func display(isLoading: Bool) {
            messages.append(.display(isLoading: isLoading))
        }
    }

}
