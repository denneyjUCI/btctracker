//
//  ExchangePresenterTests.swift
//  BTCTrackerTests
//
//  Created by Jonathan Denney on 9/14/24.
//

import XCTest
import BTCTracker

struct ExchangeViewModel: Equatable, Hashable {

    private let exchange: Exchange

    init(exchange: Exchange) {
        self.exchange = exchange
    }

    var message: String {
        return exchange.symbol + " is worth " + String(format: "$%0.2f", exchange.rate)
    }

}

final class ExchangePresenter {
    typealias View = ExchangePresenterTests.ViewSpy

    private let view: View
    private let mapper: (Exchange) -> ExchangeViewModel
    init(view: View, mapper: @escaping (Exchange) -> ExchangeViewModel) {
        self.view = view
        self.mapper = mapper
    }

    func didStartLoading() {
        view.display(isLoading: true)
    }

    func didFinishLoading(with exchange: Exchange) {
        view.display(error: nil)
        view.display(isLoading: false)
        view.display(viewModel: mapper(exchange))
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

    func test_didFinishLoadingExchange_displaysMappedMessageAndStopsLoading() {
        let exchange = Exchange(symbol: "any symbol", rate: 300.0)
        let makeViewModel = { exchange in ExchangeViewModel(exchange: exchange) }
        let (sut, view) = makeSUT(mapper: makeViewModel)

        sut.didFinishLoading(with: exchange)

        XCTAssertEqual(view.messages, [
            .display(error: nil),
            .display(message: "any symbol is worth $300.00"),
            .display(isLoading: false)
        ])
    }

    // MARK: - Helpers
    private func makeSUT(
        mapper: @escaping (Exchange) -> ExchangeViewModel = { _ in ExchangeViewModel(exchange: Exchange(symbol: "any", rate: 0)) },
        file: StaticString = #filePath,
        line: UInt = #line)
    -> (sut: ExchangePresenter, view: ViewSpy) {
        let view = ViewSpy()
        let sut = ExchangePresenter(view: view, mapper: mapper)
        trackForMemoryLeaks(view, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, view)
    }

    final class ViewSpy {
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
