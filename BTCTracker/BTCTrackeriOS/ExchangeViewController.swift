//
//  ExchangeViewController.swift
//  BTCTrackeriOS
//
//  Created by Jonathan Denney on 9/19/24.
//

import UIKit
import BTCTracker

public class ExchangeViewController: UIViewController {

    public let valueLabel = UILabel()
    public let symbolLabel = UILabel()
    public let errorLabel = UILabel()

    private var onViewLoad: (() -> Void)!

    public convenience init(onViewLoad: @escaping () -> Void) {
        self.init()

        self.onViewLoad = onViewLoad
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        onViewLoad()
    }

    public func display(error: String) {
        errorLabel.text = error
    }

    public func display(_ exchange: ExchangeViewModel) {
        valueLabel.text = exchange.price
        symbolLabel.text = exchange.symbol
        errorLabel.text = nil
    }

}
