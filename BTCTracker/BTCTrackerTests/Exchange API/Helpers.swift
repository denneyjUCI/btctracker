//
//  Helpers.swift
//  BTCTrackerTests
//
//  Created by Jonathan Denney on 9/12/24.
//

import Foundation

func anyHTTPURLResponse(code: Int = 200) -> HTTPURLResponse {
    let url = URL(string: "http://any-url.com")!
    return HTTPURLResponse(url: url, statusCode: code, httpVersion: nil, headerFields: nil)!
}
