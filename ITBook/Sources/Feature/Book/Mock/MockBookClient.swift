//
//  MockBookClient.swift
//  ITBook
//
//  Created by TAE SU LEE on 1/11/24.
//  Copyright © 2024 https://github.com/tsleedev. All rights reserved.
//

import Foundation

struct MockBookClient: BookClient {
    var bookItem: BookItem?
    var error: Error?

    func book(isbn13: String) async throws -> BookItem {
        if let error = self.error {
            throw error
        }
        if let bookItem = self.bookItem {
            return bookItem
        }
        return .mock // 기본 목 데이터
    }
}
