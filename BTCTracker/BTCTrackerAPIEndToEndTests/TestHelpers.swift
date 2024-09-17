//
//  TestHelpers.swift
//  BTCTrackerAPIEndToEndTests
//
//  Created by Jonathan Denney on 9/15/24.
//

import BTCTracker
import XCTest

extension XCTestCase {

    func loadResult(from url: URL, file: StaticString = #filePath, line: UInt = #line) -> HTTPClient.Result {
        let session = URLSession(configuration: .ephemeral)
        let client = URLSessionHTTPClient(session: session)
        trackForMemoryLeaks(client, file: file, line: line)
        let exp = expectation(description: "Wait for load")

        var capturedResult: HTTPClient.Result!
        client.get(request: .init(url: url)) { result in
            capturedResult = result
            exp.fulfill()
        }

        wait(for: [exp], timeout: 10)
        return capturedResult
    }
    
}
