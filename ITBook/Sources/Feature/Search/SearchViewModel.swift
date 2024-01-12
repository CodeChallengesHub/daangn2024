//
//  SearchViewModel.swift
//  ITBook
//
//  Created by TAE SU LEE on 1/10/24.
//  Copyright © 2024 https://github.com/tsleedev. All rights reserved.
//

import Foundation

class SearchViewModel {
    // MARK: - Published
    @Published var items: [SearchItem] = []
    var hasNextPage: Bool = true // 마지막 페이지 인지 체크 하는 flag
    
    // MARK: - Properties
    private var total: Int = 0
    private var page: Int = 1
    private var keyword: String?
    
    // MARK: - Initialize with Client
    private let searchClient: SearchClient
    
    init(searchClient: SearchClient) {
        self.searchClient = searchClient
    }
}

// MARK: - Search Handling
extension SearchViewModel {
    func search(keyword: String) async {
        self.keyword = keyword
        await performSearch(withKeyword: keyword, forPage: 1)
    }
    
    func searchNextPage() async {
        guard let keyword = keyword, hasNextPage else { return }
        await performSearch(withKeyword: keyword, forPage: page + 1)
    }
    
    func clearSearchResults() {
        items.removeAll()
        total = 0
        page = 1
        hasNextPage = true
        keyword = nil
    }
}

// MARK: - Helper
private extension SearchViewModel {
    func performSearch(withKeyword keyword: String, forPage pageNumber: Int) async {
        do {
            let result = try await searchClient.search(keyword: keyword, page: pageNumber)
            updateSearchResults(with: result, isNextPage: pageNumber > 1)
        } catch {
            print(error)
        }
    }
    
    func updateSearchResults(with result: SearchResult, isNextPage: Bool) {
        total = result.total
        page = result.page
        if isNextPage {
            items.append(contentsOf: result.books)
        } else {
            items = result.books
        }
        updateHasNextPage()
    }
    
    func updateHasNextPage() {
        let currentPageItemCount = page * 10
        hasNextPage = total > currentPageItemCount
    }
}

#if DEBUG
struct _SearchInternalState {
    var total: Int = 0
    var page: Int = 1
    var hasNextPage: Bool = true
    var keyword: String?
}
extension SearchViewModel {
    func _test_internalState() -> _SearchInternalState {
        return .init(total: total, page: page, hasNextPage: hasNextPage, keyword: keyword)
    }
}
#endif
