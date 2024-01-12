//
//  RealSearchClient.swift
//  ITBook
//
//  Created by TAE SU LEE on 1/10/24.
//  Copyright © 2024 https://github.com/tsleedev. All rights reserved.
//

import Foundation

struct RealSearchClient: SearchClient {
    private let service = SearchAPIService()
    
    func search(keyword: String, page: Int) async throws -> SearchResult {
        do {
            let data = try await service.request(.search(keyword: keyword, page: page))
            
            // JSON 데이터를 SearchResult 타입으로 디코딩
            let decoder = JSONDecoder()
            let searchResult = try decoder.decode(SearchResult.self, from: data)
            return searchResult
        } catch {
            throw error
        }
    }
}
