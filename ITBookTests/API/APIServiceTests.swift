//
//  APIServiceTests.swift
//  ITBookTests
//
//  Created by TAE SU LEE on 1/13/24.
//  Copyright © 2024 https://github.com/tsleedev. All rights reserved.
//

import XCTest
@testable import ITBook

final class APIServiceTests: XCTestCase {
    // 서버로부터 성공적인 응답을 받았을 때의 처리를 검증
    // 이 테스트는 APIService가 HTTP 상태 코드 200과 함께 올바른 데이터를 반환하는지 확인
    func testSuccessfulResponse() async {
        var mockSession = APIMockURLSession()
        let fakeData = Data("fake response".utf8)
        mockSession.requestData = fakeData
        mockSession.requestResponse = HTTPURLResponse(
            url: URL(string: "https://test.com")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        let service = SearchAPIService(session: mockSession)

        do {
            let data = try await service.request(.search(keyword: "swift", page: 1))
            XCTAssertEqual(data, fakeData, "Data should match the fake response data")
        } catch {
            XCTFail("Request should succeed, but it failed with error: \(error)")
        }
    }
    
    // 네트워크 오류 시나리오 (예: 인터넷 연결 끊김)를 테스트
    // 이 테스트는 APIService가 네트워크 오류를 적절히 감지하고 처리하는지 확인
    func testRequestWithError() async {
        var mockSession = APIMockURLSession()
        let expectedError = URLError(.notConnectedToInternet)
        mockSession.requestError = expectedError
        let service = SearchAPIService(session: mockSession)
        
        do {
            _ = try await service.request(.search(keyword: "swift", page: 1))
            XCTFail("Request should fail, but it succeeded")
        } catch {
            XCTAssertEqual(error as? URLError, expectedError)
        }
    }
    
    // 서버로부터의 비정상적인 HTTP 상태 코드 (예: 400 Bad Request)에 대한 처리를 테스트
    // 이 테스트는 APIService가 오류 상태 코드를 올바르게 처리하고 적절한 오류를 반환하는지 확인
    func testRequestWithDifferentStatusCodes() async {
        var mockSession = APIMockURLSession()
        mockSession.requestResponse = HTTPURLResponse(
            url: URL(string: "https://test.com")!,
            statusCode: 400,
            httpVersion: nil,
            headerFields: nil
        )
        let service = SearchAPIService(session: mockSession)
        
        do {
            _ = try await service.request(.search(keyword: "swift", page: 1))
            XCTFail("Request should fail, but it succeeded")
        } catch {
            XCTAssertEqual(error as? URLError, URLError(.badServerResponse))
        }
    }
    
    // 요청이 타임아웃에 도달하는 경우의 처리를 검증
    // 이 테스트는 APIService가 네트워크 타임아웃 발생 시 적절한 오류를 반환하는지 확인
    func testRequestTimeout() async {
        var mockSession = APIMockURLSession()
        mockSession.requestError = URLError(.timedOut)
        let service = SearchAPIService(session: mockSession)

        do {
            _ = try await service.request(.search(keyword: "swift", page: 1))
            XCTFail("Request should fail due to timeout")
        } catch {
            XCTAssertEqual((error as? URLError)?.code, .timedOut, "Error should be a timeout error")
        }
    }
}
