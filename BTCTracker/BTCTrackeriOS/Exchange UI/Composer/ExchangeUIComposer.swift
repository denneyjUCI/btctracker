//
//  ExchangeUIComposer.swift
//  BTCTrackeriOS
//
//  Created by Jonathan Denney on 9/25/24.
//

import UIKit

public enum ExchangeUIComposer {
    public static func exchangeComposedWith(onViewLoad: @escaping () -> Void) -> ExchangeViewController {
        let bundle = Bundle(for: ExchangeViewController.self)
        let storyboard = UIStoryboard(name: "Exchange", bundle: bundle)
        let vc = storyboard.instantiateInitialViewController() as! ExchangeViewController

        vc.onViewLoad = onViewLoad
        return vc
    }
}
