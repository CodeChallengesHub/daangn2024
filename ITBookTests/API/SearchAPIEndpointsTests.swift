//
//  APIServiceTests.swift
//  ITBookTests
//
//  Created by TAE SU LEE on 1/11/24.
//  Copyright © 2024 https://github.com/tsleedev. All rights reserved.
//

import XCTest
@testable import ITBook

final class SearchAPIEndpointsTests: XCTestCase {
    var apiService: APIService<SearchAPI>!
    var mockSession: APIMockURLSession!
    
    override func setUpWithError() throws {
        mockSession = APIMockURLSession()
        apiService = SearchAPIService(session: mockSession)
    }
    
    override func tearDownWithError() throws {
        apiService = nil
    }
    
    func testWhenRequestSuccessful_ReturnsEmptyData() async {
        let jsonString = """
        {"error":"0","total":"0","books":[]}
        """
        guard let jsonData = jsonString.data(using: .utf8) else {
            XCTFail("Failed to convert JSON string to Data")
            return
        }

        mockSession.requestData = jsonData
        mockSession.requestResponse = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        do {
            let data = try await apiService.request(.search(keyword: "swift", page: 1))
            // 성공적으로 데이터를 받았는지 확인
            XCTAssertNotNil(data)
        } catch {
            XCTFail("Request should succeed, but it failed with error: \(error)")
        }
    }
}
