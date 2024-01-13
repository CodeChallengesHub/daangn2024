//
//  BookViewModelTests.swift
//  ITBookTests
//
//  Created by TAE SU LEE on 1/13/24.
//  Copyright © 2024 https://github.com/tsleedev. All rights reserved.
//

import XCTest
import Combine
@testable import ITBook

final class BookViewModelTests: XCTestCase {
    private var cancellables: Set<AnyCancellable> = []
    
    // 책 정보의 가져오기 성공을 테스트
    // 이 테스트는 네트워크 요청이 성공할 경우, 해당 책 정보가 올바르게 로드되고 isLoading 상태가 false로 업데이트되는지 확인
    func testFetchSuccess() {
        var mockBookClient = MockBookClient()
        mockBookClient.bookItem = .mock
        let viewModel = BookViewModel(bookClient: mockBookClient, isbn13: "1234")
        
        let itemLoadedExpectation = XCTestExpectation(description: "Item should be loaded")
        let loadingFinishedExpectation = XCTestExpectation(description: "Loading should be finished")
        
        viewModel.$isLoading
            .dropFirst() // 초기값 false 혹은 네트워크 요청 중인 true를 제거
            .sink { isLoading in
                if !isLoading { // 네트워크 요청이 완료된 것
                    loadingFinishedExpectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        viewModel.$item
            .filter { $0 != nil }
            .sink { _ in
                itemLoadedExpectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [loadingFinishedExpectation, itemLoadedExpectation], timeout: 5.0)
    }
    
    // 책 정보 가져오기 실패를 테스트
    // 이 테스트는 네트워크 요청이 실패할 경우, 에러가 발생하고 isLoading 상태가 false로 업데이트되는지 확인
    func testFetchFailure() {
        var mockBookClient = MockBookClient()
        mockBookClient.error = NSError(domain: "TestError", code: 0, userInfo: nil)
        let viewModel = BookViewModel(bookClient: mockBookClient, isbn13: "1234")
        
        let fetchErrorExpectation = XCTestExpectation(description: "Handle fetch failure")
        let loadingFinishedExpectation = XCTestExpectation(description: "Loading should be finished")
        
        viewModel.$isLoading
            .dropFirst() // 초기값 false 혹은 네트워크 요청 중인 true를 제거
            .sink { isLoading in
                if !isLoading { // 네트워크 요청이 완료된 것
                    loadingFinishedExpectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        viewModel.$error
            .filter { $0 != nil }
            .map { $0! }
            .sink { error in
                XCTAssertNotNil(error)
                fetchErrorExpectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [loadingFinishedExpectation, fetchErrorExpectation], timeout: 5.0)
    }
}
