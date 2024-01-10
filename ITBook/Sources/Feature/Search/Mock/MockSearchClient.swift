//
//  MockSearchClient.swift
//  ITBook
//
//  Created by TAE SU LEE on 1/10/24.
//  Copyright © 2024 https://github.com/tsleedev. All rights reserved.
//

import Foundation

struct MockSearchClient: SearchClient {
    func search(keyword: String, page: Int) async throws -> SearchResult {
        switch page {
        case 1:
            return .mock1
        case 2:
            return .mock2
        default:
            return .mock2
        }
    }
}
