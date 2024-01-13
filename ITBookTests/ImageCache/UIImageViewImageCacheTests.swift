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
    var mockFileManager: ImageMockFileManager!
    
    override func setUpWithError() throws {
        mockFileManager = ImageMockFileManager()
        ImageCache.shared.setFileManagerForTesting(fileManager: mockFileManager)
    }
    
    // UIImageView의 setImage(with:) 메서드가 새로운 이미지 요청을 시작할 때 이전 요청을 취소하는지 확인하는 테스트
    func testImageViewSetImageCancelsPreviousRequest() {
        let mockSession = ImageMockURLSession()
        let expectedData = UIImage(systemName: "star")!.pngData()!
        mockSession.imageData = expectedData
        ImageCache.shared.setSessionForTesting(session: mockSession)
        
        let imageView = UIImageView()
        
        // 첫 번째 이미지 로드
        let firstURL = URL(string: "https://test.com/first.jpg")!
        imageView.setImage(with: firstURL.absoluteString)
        
        // 첫 번째 요청의 MockURLSessionDataTask를 가져옴
        let firstTask = mockSession.taskMap[firstURL]
        
        // 두 번째 이미지 로드
        let secondURL = URL(string: "https://test.com/second.jpg")!
        imageView.setImage(with: secondURL.absoluteString)
        
        // 첫 번째 요청이 취소되었는지 확인
        XCTAssertTrue(firstTask?.isCancelled ?? false, "First task should be cancelled")
        
        // 두 번째 요청의 MockURLSessionDataTask를 가져옴
        let secondTask = mockSession.taskMap[secondURL]
        
        // 두 번째 요청이 진행 중인지 확인
        XCTAssertTrue(secondTask?.isResumed ?? false, "Second task should be running")
    }
}
