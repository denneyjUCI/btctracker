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

    @IBOutlet public private(set) var symbolLabel: UILabel!
    @IBOutlet public private(set) var valueLabel: UILabel!
    @IBOutlet public private(set) var errorLabel: UILabel!

    var onViewLoad: (() -> Void)!

    public override func viewDidLoad() {
        super.viewDidLoad()

        valueLabel.text = nil
        symbolLabel.text = "-"
        errorLabel.text = nil
        onViewLoad()
    }
}

extension ExchangeViewController: ExchangeErrorView {
    public func display(error: String?) {
        errorLabel.text = error
    }
}

extension ExchangeViewController: ExchangeView {
    public func display(viewModel exchange: ExchangeViewModel) {
        valueLabel.text = exchange.price
        symbolLabel.text = exchange.symbol
        errorLabel.text = nil
    }

}
