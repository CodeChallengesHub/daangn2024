//
//  RealBookClient.swift
//  ITBook
//
//  Created by TAE SU LEE on 1/12/24.
//  Copyright © 2024 https://github.com/tsleedev. All rights reserved.
//

import Foundation

struct RealBookClient: BookClientProtocol {
    private let service = SearchAPIService()
    
    func book(isbn13: String) async throws -> BookItem {
        do {
            let data = try await service.request(.book(isbn13: isbn13))
            let decoder = JSONDecoder()
            let item = try decoder.decode(BookItem.self, from: data)
            return item
        } catch {
            throw error
        }
    }
}
