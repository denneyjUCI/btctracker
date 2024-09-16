//
//  main.swift
//  PrototypeCLI
//
//  Created by Jonathan Denney on 9/16/24.
//

import Foundation

class ConsoleApp {

    private var lastUpdatedTime: Date?

    private let stdOut: FileHandle = FileHandle(fileDescriptor: STDOUT_FILENO)
    private let stdError: FileHandle = FileHandle(fileDescriptor: STDERR_FILENO)

    func tick() {
        let random = Int.random(in: 1...5)
        if random % 4 == 0 {
            var text = "Failed to update value."
            if let lastUpdatedTime {
                let formatter = DateFormatter()
                formatter.dateStyle = .short
                formatter.timeStyle = .short
                text = "Update failed. Displaying last value from \(formatter.string(from: lastUpdatedTime))"
            }

            text += "\n"

            if let data = text.data(using: .utf8) {
                stdError.write(data)
            }
        } else {
            if let data = String(format: "%0.2f\n", Double.random(in: 30000...32000)).data(using: .utf8) {
                stdOut.write(data)
            }
            lastUpdatedTime = Date()
        }
    }
}

let app = ConsoleApp()
print("Loading....")
repeat {
    Thread.sleep(forTimeInterval: 1)
    app.tick()
} while (true)
