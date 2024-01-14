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
    var mockFileManager: ImageMockFileManager!
    
    override func setUpWithError() throws {
        mockFileManager = ImageMockFileManager()
        ImageCache.shared.setFileManagerForTesting(fileManager: mockFileManager)
    }
    
    // ImageCache가 네트워크에서 이미지를 성공적으로 로드하고, 해당 이미지를 메모리와 파일에 저장하는지 검증하는 테스트
    func testLoadImageFromNetwork() {
        let mockSession = ImageMockURLSession()
        let expectedData = UIImage(systemName: "star")!.pngData()!
        let cacheKey = "https://test.com/image.png"
        mockSession.imageData = expectedData
        ImageCache.shared.setSessionForTesting(session: mockSession)
        
        let expectation = XCTestExpectation(description: "Load image from network")
        
        _ = ImageCache.shared.loadImage(from: URL(string: cacheKey)!) { image in
            XCTAssertNotNil(image, "Loaded image should not be nil")
//            XCTAssertEqual(image!.pngData()!, expectedData, "Loaded image should match the network image")
            
            // 메모리 캐시에 이미지가 존재하는지 확인
            let cachedImage = ImageCache.shared.getCachedImage(forKey: cacheKey)
            XCTAssertNotNil(cachedImage, "Image should be cached in memory")

            // 디스크 캐시에 저장되었는지 확인
            let cacheDirectory = self.mockFileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
            let filePath = cacheDirectory.appendingPathComponent(URL(string: cacheKey)!.lastPathComponent)
            XCTAssertTrue(self.mockFileManager.fileExists(atPath: filePath.path), "Image should be saved to disk cache")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    // 이미지 로드 실패 시의 동작을 테스트
    func testLoadImageFailure() {
        let mockSession = ImageMockURLSession()
        mockSession.imageData = nil
        mockSession.error = NSError(domain: "com.testError", code: 404, userInfo: nil)
        ImageCache.shared.setSessionForTesting(session: mockSession)
        
        let expectation = XCTestExpectation(description: "Image load should fail")
        
        _ = ImageCache.shared.loadImage(from: URL(string: "https://test.com/failure.jpg")!) { image in
            XCTAssertNil(image, "Image load should fail and result should be nil")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
}
