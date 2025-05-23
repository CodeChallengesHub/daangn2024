//
//  BookViewModel.swift
//  ITBook
//
//  Created by TAE SU LEE on 1/11/24.
//  Copyright © 2024 https://github.com/tsleedev. All rights reserved.
//

import Core
import Foundation

class BookViewModel {
    // MARK: - Published
    @Published var item: BookItem?
    @Published var isLoading: Bool = false
    @Published var error: Error?
    
    // MARK: - Initialize with Client
    private let bookClient: BookClientProtocol
    
    init(bookClient: BookClientProtocol, isbn13: String) {
        self.bookClient = bookClient
        Task {
            await fetch(isbn13: isbn13)
        }
    }
}

// MARK: - Network Handling
private extension BookViewModel {
    func fetch(isbn13: String) async {
        do {
            isLoading = true
            let result = try await bookClient.book(isbn13: isbn13)
            item = result
        } catch {
            TSLogger.error(error)
            self.error = error
        }
        isLoading = false
    }
}
