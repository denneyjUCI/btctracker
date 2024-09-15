//
//  ExchangePresenter.swift
//  BTCTracker
//
//  Created by Jonathan Denney on 9/14/24.
//

import Foundation

public protocol ExchangeLoadingView {
    func display(isLoading: Bool)
}

public protocol ExchangeErrorView {
    func display(error: String?)
}

public protocol ExchangeView {
    func display(viewModel: ExchangeViewModel)
}

public final class ExchangePresenter {

    private let loadingView: ExchangeLoadingView
    private let errorView: ExchangeErrorView
    private let exchangeView: ExchangeView
    private let mapper: (Exchange) -> ExchangeViewModel
    private let currentDate: () -> Date
    private var lastUpdated: Date?
    private let dateFormatter: DateFormatter

    private var failureMessage: String {
        var message = "Failed to update value."
        if let lastUpdated = lastUpdated {
            message += " Showing last updated value from \(dateFormatter.string(from: lastUpdated))"
        }
        return message
    }

    public init(exchangeView: ExchangeView, loadingView: ExchangeLoadingView, errorView: ExchangeErrorView, mapper: @escaping (Exchange) -> ExchangeViewModel, locale: Locale = .current, timeZone: TimeZone = .current, currentDate: @escaping () -> Date) {
        self.exchangeView = exchangeView
        self.loadingView = loadingView
        self.errorView = errorView
        self.mapper = mapper
        self.currentDate = currentDate
        let formatter = DateFormatter()
        formatter.locale = locale
        formatter.timeZone = timeZone
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        dateFormatter = formatter
    }

    public func didStartLoading() {
        loadingView.display(isLoading: true)
    }

    public func didFinishLoading(with exchange: Exchange) {
        errorView.display(error: nil)
        loadingView.display(isLoading: false)
        exchangeView.display(viewModel: mapper(exchange))
        lastUpdated = currentDate()
    }

    public func didFinishLoading(with error: Error) {
        loadingView.display(isLoading: false)
        errorView.display(error: failureMessage)
    }
}
