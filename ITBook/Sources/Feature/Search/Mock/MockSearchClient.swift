//
//  MockSearchClient.swift
//  ITBook
//
//  Created by TAE SU LEE on 1/10/24.
//  Copyright © 2024 https://github.com/tsleedev. All rights reserved.
//

import Foundation

struct MockSearchClient: SearchClient {
    var searchResults: [Int: SearchResult] = [:]
    var error: Error?
    
    func search(keyword: String, page: Int) async throws -> SearchResult {
//        if #available(iOS 16.0, *) {
//            try await Task.sleep(for: .seconds(1))
//        } else {
//            // Fallback on earlier versions
//        }
        if let error = error {
            throw error
        }
        return searchResults[page] ?? .mock1
    }
}
