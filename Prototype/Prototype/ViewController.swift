//
//  ViewController.swift
//  Prototype
//
//  Created by Jonathan Denney on 9/14/24.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var exchangeLabel: UILabel!
    @IBOutlet var errorLabel: UILabel!
    
    private var timer: Timer?
    private var lastUpdatedTime: Date?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Loading..."
        errorLabel.isHidden = true
        exchangeLabel.text = "-"
        startTimer()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        timer?.invalidate()
    }

    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] _ in
            self?.tick()
        })
    }

    func tick() {
        title = ""
        let random = Int.random(in: 1...5)
        if random % 4 == 0 {
            var text = "Failed to update value."
            if let lastUpdatedTime {
                let formatter = DateFormatter()
                formatter.dateStyle = .short
                formatter.timeStyle = .short
                text = "Update failed. Displaying last value from \(formatter.string(from: lastUpdatedTime))"
            }
            errorLabel.isHidden = false
            errorLabel.text = text
        } else {
            exchangeLabel.text = String(format: "%0.2f", Double.random(in: 30000...32000))
            errorLabel.isHidden = true
            lastUpdatedTime = Date()
        }
    }

}

