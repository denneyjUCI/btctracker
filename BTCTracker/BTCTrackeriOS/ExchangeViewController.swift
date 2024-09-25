//
//  ExchangeViewController.swift
//  BTCTrackeriOS
//
//  Created by Jonathan Denney on 9/19/24.
//

import UIKit
import BTCTracker

public enum ExchangeUIComposer {
    public static func exchangeComposedWith(onViewLoad: @escaping () -> Void) -> ExchangeViewController {
        let bundle = Bundle(for: ExchangeViewController.self)
        let storyboard = UIStoryboard(name: "Exchange", bundle: bundle)
        let vc = storyboard.instantiateInitialViewController() as! ExchangeViewController

        vc.onViewLoad = onViewLoad
        return vc
    }
}

public class ExchangeViewController: UIViewController {

    public let valueLabel = UILabel()
    public let symbolLabel = UILabel()
    public let errorLabel = UILabel()

    var onViewLoad: (() -> Void)!

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
