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
    // 첫 페이지와 다음 페이지에 대한 검색 결과를 테스트
    // 이 테스트는 사용자가 키워드로 검색을 수행하고, 결과의 첫 페이지와 다음 페이지를 연속적으로 불러올 수 있는지를 검증
    func testSearchFirstAndNextPage() async {
        var mockSearchClient = MockSearchClient()
        mockSearchClient.searchResults = [  // 총 2페이지, 19개 아이템
            1: .mock1,                      // 1페이지 10개
            2: .mock2                       // 2페이지 9개
        ]
        let viewModel = SearchViewModel(searchClient: mockSearchClient)
        
        await viewModel.search(keyword: "swift")
        
        XCTAssertEqual(viewModel.items, SearchResult.mock1.books)
        let firstState = viewModel._test_internalState()
        XCTAssertEqual(firstState.total, SearchResult.mock1.total)
        XCTAssertEqual(firstState.page, SearchResult.mock1.page)
        XCTAssertEqual(firstState.hasNextPage, true)
        XCTAssertEqual(firstState.keyword, "swift")
        
        await viewModel.searchNextPage()

        XCTAssertEqual(viewModel.items, SearchResult.mock1.books + SearchResult.mock2.books)
        let secondState = viewModel._test_internalState()
        XCTAssertEqual(secondState.total, SearchResult.mock2.total)
        XCTAssertEqual(secondState.page, SearchResult.mock2.page)
        XCTAssertEqual(secondState.hasNextPage, false)
        XCTAssertEqual(secondState.keyword, "swift")
    }
    
    // 사용자가 빠르게 스크롤하여 '다음 페이지' 검색을 거의 동시에 여러 번 요청하는 상황을 테스트
    // 이 테스트는 ViewModel이 동시에 발생하는 여러 페이지 요청을 적절히 처리하고, 중복된 데이터 로딩이 발생하지 않도록 하는지를 검증
    func testSimultaneousSearchNextPageCalls() async {
        var mockSearchClient = MockSearchClient()
        mockSearchClient.searchResults = [
            1: .mock1,
            2: .mock2
        ]
        let viewModel = SearchViewModel(searchClient: mockSearchClient)

        // 첫 페이지 검색
        await viewModel.search(keyword: "swift")
        
        // 동시에 두 번의 '다음 페이지' 검색을 시뮬레이션
        // 이는 사용자가 빠르게 스크롤하여 페이지를 연속적으로 요청하는 상황을 모방
        let firstConcurrentFetchExpectation = XCTestExpectation(description: "First concurrent fetch completed")
        let secondConcurrentFetchExpectation = XCTestExpectation(description: "Second concurrent fetch completed")
        
        Task {
            await viewModel.searchNextPage()
            firstConcurrentFetchExpectation.fulfill()
        }
        Task {
            await viewModel.searchNextPage()
            secondConcurrentFetchExpectation.fulfill()
        }
        
        await fulfillment(of: [firstConcurrentFetchExpectation, secondConcurrentFetchExpectation], timeout: 5.0)
        
        // 검증: 두 번째 페이지가 중복 로드되지 않았는지 확인
        // 예상되는 결과는 첫 번째와 두 번째 페이지의 결과가 한 번씩만 합쳐진 것
        XCTAssertEqual(viewModel.items, SearchResult.mock1.books + SearchResult.mock2.books)
        let finalState = viewModel._test_internalState()
        XCTAssertEqual(finalState.total, SearchResult.mock2.total)
        XCTAssertEqual(finalState.page, SearchResult.mock2.page)
        XCTAssertEqual(finalState.hasNextPage, false)
        XCTAssertEqual(finalState.keyword, "swift")
    }
    
    // 검색 결과를 초기화하는 기능을 테스트
    // 검색 후 결과를 초기화하고, 모든 상태가 올바르게 리셋되는지 확인
    func testClearSearchResults() async {
        var mockSearchClient = MockSearchClient()
        mockSearchClient.searchResults = [
            1: .mock1,
            2: .mock2
        ]
        let viewModel = SearchViewModel(searchClient: mockSearchClient)
        
        await viewModel.search(keyword: "swift")
        viewModel.clearSearchResults()
        XCTAssertTrue(viewModel.items.isEmpty)
        let state = viewModel._test_internalState()
        XCTAssertEqual(state.total, 0)
        XCTAssertEqual(state.page, 1)
        XCTAssertEqual(state.hasNextPage, true)
        XCTAssertEqual(state.keyword, nil)
    }
    
    // 검색 결과가 없는 경우의 처리를 테스트합니다.
    func testSearchWithNoResults() async {
        var mockSearchClient = MockSearchClient()
        // 빈 결과를 반환하도록 설정
        mockSearchClient.searchResults = [
            1: .init(total: 0, page: 1, books: [])
        ]
        let viewModel = SearchViewModel(searchClient: mockSearchClient)
        
        // 검색 결과가 없는 검색어로 검색 시도
        await viewModel.search(keyword: "nonexistent")
        
        // 검증: 검색 결과가 없는 경우 적절한 처리가 이루어졌는지 확인
        XCTAssertTrue(viewModel.items.isEmpty)
        let state = viewModel._test_internalState()
        XCTAssertEqual(state.total, 0)
        XCTAssertEqual(state.page, 1)
        XCTAssertEqual(state.hasNextPage, false)
        XCTAssertEqual(state.keyword, "nonexistent")
    }
                                
    // 네트워크 요청 실패 시의 처리를 테스트
    func testSearchFailureHandling() async {
        var mockSearchClient = MockSearchClient()
        mockSearchClient.error = NSError(domain: "NetworkError", code: -1, userInfo: nil)
        let viewModel = SearchViewModel(searchClient: mockSearchClient)
        
        await viewModel.search(keyword: "swift")
        
        // 검증: 에러가 발생했을 때 적절한 처리가 이루어졌는지 확인
        XCTAssertTrue(viewModel.items.isEmpty, "에러 상황에서 items는 비어있어야 함")
        XCTAssertNotNil(viewModel.alertMessage, "에러 상황에서 alertMessage는 NotNil 이어야 함")
    }
}
