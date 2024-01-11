//
//  ImageCacheTests.swift
//  ITBookTests
//
//  Created by TAE SU LEE on 1/11/24.
//  Copyright © 2024 https://github.com/tsleedev. All rights reserved.
//

import XCTest
@testable import ITBook

final class ImageCacheTests: XCTestCase {
    func testImageCacheLoadsImageSuccessfully() {
        // 모의 URLSession 및 데이터 준비
        let mockSession = ImageMockURLSession()
        let expectedData = UIImage(systemName: "star")!.pngData()!
        mockSession.nextData = expectedData
        
        // ImageCache에 MockURLSession 주입
        ImageCache.shared.setSessionForTesting(session: mockSession)

        let expectation = self.expectation(description: "ImageCache loads image from URL")

        // 예상되는 URL
        let url = URL(string: "https://example.com/image.png")!

        _ = ImageCache.shared.loadImage(from: url) { image in
            XCTAssertNotNil(image, "Image should be loaded")
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)

        // 요청이 시작되었는지 확인
        XCTAssertTrue(mockSession.nextDataTask.isResumed, "Data task should be resumed")
    }
}

