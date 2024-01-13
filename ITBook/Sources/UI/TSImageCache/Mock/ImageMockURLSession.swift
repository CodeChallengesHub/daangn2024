//
//  ImageMockURLSession.swift
//  ITBook
//
//  Created by TAE SU LEE on 1/11/24.
//  Copyright © 2024 https://github.com/tsleedev. All rights reserved.
//

import Foundation

struct ImageMockURLSession: ImageSessionProtocol {
    var nextDataTask = MockURLSessionDataTask()
    var nextData: Data?
    var nextError: Error?

    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> ImageSessionDataTaskProtocol {
        completionHandler(nextData, nil, nextError)
        return nextDataTask
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
