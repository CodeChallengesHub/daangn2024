//
//  ImageMockURLSession.swift
//  ITBook
//
//  Created by TAE SU LEE on 1/11/24.
//  Copyright © 2024 https://github.com/tsleedev. All rights reserved.
//

import Foundation

class ImageMockURLSession: ImageSessionProtocol {
    var imageData: Data?
    var error: Error?
    var taskMap = [URL: MockURLSessionDataTask]()

    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> ImageSessionDataTaskProtocol {
        let dataTask = MockURLSessionDataTask()
        taskMap[url] = dataTask
        completionHandler(imageData, nil, error)
        return dataTask
    }
}

class MockURLSessionDataTask: ImageSessionDataTaskProtocol {
    private(set) var isResumed = false
    private(set) var isCancelled = false

    func resume() {
        isResumed = true
    }

    func cancel() {
        isCancelled = true
    }
}
