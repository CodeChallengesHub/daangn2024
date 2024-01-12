//
//  SearchViewModelTests.swift
//  ITBookTests
//
//  Created by TAE SU LEE on 1/11/24.
//  Copyright © 2024 https://github.com/tsleedev. All rights reserved.
//

import XCTest
@testable import ITBook

final class SearchViewModelTests: XCTestCase {
    var viewModel: SearchViewModel!
    var mockSearchClient: MockSearchClient!
    
    override func setUpWithError() throws {
        mockSearchClient = MockSearchClient()
        viewModel = SearchViewModel(searchClient: mockSearchClient)
    }

    override func tearDownWithError() throws {
        viewModel = nil
        mockSearchClient = nil
    }

    func testSearchFirstPage() async {
        await viewModel.search(keyword: "swift")
        
        XCTAssertEqual(viewModel.items, SearchResult.mock1.books)
        let state = viewModel._test_internalState()
        XCTAssertEqual(state.total, SearchResult.mock1.total)
        XCTAssertEqual(state.page, SearchResult.mock1.page)
        XCTAssertEqual(state.hasNextPage, true)
        XCTAssertEqual(state.keyword, "swift")
    }

    func testSearchNextPage() async {
        await viewModel.search(keyword: "swift")
        await viewModel.searchNextPage()

        XCTAssertEqual(viewModel.items, SearchResult.mock1.books + SearchResult.mock2.books)
        let state = viewModel._test_internalState()
        XCTAssertEqual(state.total, SearchResult.mock2.total)
        XCTAssertEqual(state.page, SearchResult.mock2.page)
        XCTAssertEqual(state.hasNextPage, false)
        XCTAssertEqual(state.keyword, "swift")
    }

    func testClearSearchResults() async {
        await viewModel.search(keyword: "swift")
        viewModel.clearSearchResults()
        XCTAssertTrue(viewModel.items.isEmpty)
        let state = viewModel._test_internalState()
        XCTAssertEqual(state.total, 0)
        XCTAssertEqual(state.page, 1)
        XCTAssertEqual(state.hasNextPage, true)
        XCTAssertEqual(state.keyword, nil)
    }
}
