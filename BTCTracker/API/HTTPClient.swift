//
//  HTTPClient.swift
//  BTCTracker
//
//  Created by Jonathan Denney on 9/11/24.
//

import Foundation

protocol HTTPClient {
    func get(request: URLRequest, completion: (Result<(Data, HTTPURLResponse), Error>) -> Void)
}
