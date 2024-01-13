//
//  MockSearchClient.swift
//  ITBook
//
//  Created by TAE SU LEE on 1/10/24.
//  Copyright © 2024 https://github.com/tsleedev. All rights reserved.
//

import Foundation

struct MockSearchClient: SearchClientProtocol {
    var searchResults: [Int: SearchResult] = [:]
    var error: Error?
    var delayInSeconds: TimeInterval = 0  // 딜레이 시간 (초 단위)
    
    func search(keyword: String, page: Int) async throws -> SearchResult {
        // 인위적인 딜레이 추가
        if delayInSeconds > 0 {
            try await Task.sleep(nanoseconds: UInt64(delayInSeconds * 1_000_000_000))
        }
        
        if let error = error {
            throw error
        }
        return searchResults[page] ?? .mock1
    }
}
