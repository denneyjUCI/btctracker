//
//  ExchangePresenterTests.swift
//  BTCTrackerTests
//
//  Created by Jonathan Denney on 9/14/24.
//

import XCTest
import BTCTracker

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

    func test_didFinishLoadingExchange_displaysMappedMessageAndStopsLoading() {
        let exchange = Exchange(symbol: "any symbol", rate: 300.0)
        let makeViewModel = { exchange in ExchangeViewModel(exchange: exchange) }
        let (sut, view) = makeSUT(mapper: makeViewModel)

        sut.didFinishLoading(with: exchange)

        XCTAssertEqual(view.messages, [
            .display(error: nil),
            .display(message: "any symbol exchange rate is 300.00"),
            .display(isLoading: false)
        ])
    }

    func test_didFinishLoadingWithError_stopsLoadingAndDisplaysErrorAndLastUpdatedData() {
        let (sut, view) = makeSUT()

        sut.didFinishLoading(with: anyNSError())

        XCTAssertEqual(view.messages, [
            .display(isLoading: false),
            .display(error: "Failed to update value."),
        ])
    }

    func test_didFinishLoadingWithError_afterLoadingSucceeds_stopsLoadingAndDisplaysErrorAndLastUpdatedData() {
        let exchange = Exchange(symbol: "any symbol", rate: 300.0)
        let makeViewModel = { exchange in ExchangeViewModel(exchange: exchange) }
        let fixedCurrentDate = Date(timeIntervalSince1970: 1726355960)
        let (sut, view) = makeSUT(mapper: makeViewModel, currentDate: { fixedCurrentDate })

        sut.didFinishLoading(with: exchange)
        sut.didFinishLoading(with: anyNSError())

        XCTAssertEqual(view.messages, [
            .display(error: nil),
            .display(message: "any symbol exchange rate is 300.00"),
            .display(isLoading: false),
            .display(error: "Failed to update value. Showing last updated value from Sep 14, 2024 at 11:19 PM"),
        ])
    }

    // MARK: - Helpers
    private func makeSUT(
        mapper: @escaping (Exchange) -> ExchangeViewModel = { _ in ExchangeViewModel(exchange: Exchange(symbol: "any", rate: 0)) },
        currentDate: @escaping () -> Date = Date.init,
        locale: Locale = .init(identifier: "en_US_POSIX"),
        timeZone: TimeZone = .gmt,
        file: StaticString = #filePath,
        line: UInt = #line)
    -> (sut: ExchangePresenter, view: ViewSpy) {
        let view = ViewSpy()
        let sut = ExchangePresenter(exchangeView: view, loadingView: view, errorView: view, mapper: mapper, locale: locale, timeZone: timeZone, currentDate: currentDate)
        trackForMemoryLeaks(view, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, view)
    }

    private func anyNSError() -> NSError {
        NSError(domain: "any error", code: -1)
    }

    final class ViewSpy: ExchangeView, ExchangeLoadingView, ExchangeErrorView {
        private(set) var messages = Set<Message>()
        enum Message: Hashable {
            case display(error: String?)
            case display(message: String)
            case display(isLoading: Bool)
        }

        func display(error: String?) {
            messages.insert(.display(error: error))
        }

        func display(isLoading: Bool) {
            messages.insert(.display(isLoading: isLoading))
        }

        func display(viewModel: ExchangeViewModel) {
            messages.insert(.display(message: viewModel.message))
        }
    }

}
