//
//  HTTPClient.swift
//  BTCTracker
//
//  Created by Jonathan Denney on 9/11/24.
//

import Foundation

public protocol HTTPClient {
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>
    
    func get(request: URLRequest, completion: (Result) -> Void)
}
