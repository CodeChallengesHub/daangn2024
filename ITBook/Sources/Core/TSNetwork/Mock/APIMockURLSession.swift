//
//  APIMockURLSession.swift
//  ITBook
//
//  Created by TAE SU LEE on 1/11/24.
//  Copyright © 2024 https://github.com/tsleedev. All rights reserved.
//

import Foundation

class APIMockURLSession: APISessionProtocol {
    var requestData: Data?
    var requestResponse: URLResponse?
    var requestError: Error?

    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        if let error = requestError {
            throw error
        }
        return (requestData ?? Data(), requestResponse ?? URLResponse())
    }
}
