//
//  UIImageViewImageCacheTests.swift
//  ITBookTests
//
//  Created by TAE SU LEE on 1/11/24.
//  Copyright © 2024 https://github.com/tsleedev. All rights reserved.
//

import XCTest
@testable import ITBook

final class UIImageViewImageCacheTests: XCTestCase {
    func testImageViewSetImageCancelsPreviousRequest() {
        // 모의 URLSession 및 데이터 준비
        let mockSession = ImageMockURLSession()
        let expectedData = UIImage(systemName: "star")!.pngData()!
        mockSession.nextData = expectedData
        
        // ImageCache에 MockURLSession 주입
        ImageCache.shared.setSessionForTesting(session: mockSession)
        
        let imageView = UIImageView()

        // 첫 번째 이미지 로드
        imageView.setImage(with: "https://example.com/first.jpg")

        // 첫 번째 요청의 MockURLSessionDataTask를 가져옴
        let firstTask = mockSession.nextDataTask

        // 두 번째 이미지 로드
        imageView.setImage(with: "https://example.com/second.jpg")

        // 첫 번째 요청이 취소되었는지 확인
        XCTAssertTrue(firstTask.isCancelled, "First task should be cancelled")

        // 두 번째 요청의 MockURLSessionDataTask를 가져옴
        let secondTask = mockSession.nextDataTask

        // 두 번째 요청이 진행 중인지 확인
        XCTAssertTrue(secondTask.isResumed, "Second task should be running")
    }
}

