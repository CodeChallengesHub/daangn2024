//
//  ImageSessionProtocol.swift
//  ITBook
//
//  Created by TAE SU LEE on 1/11/24.
//  Copyright © 2024 https://github.com/tsleedev. All rights reserved.
//

import Foundation

protocol ImageSessionProtocol {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> ImageSessionDataTaskProtocol
}

protocol ImageSessionDataTaskProtocol {
    func resume()
    func cancel()
}

extension URLSession: ImageSessionProtocol {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> ImageSessionDataTaskProtocol {
        let task: URLSessionDataTask = dataTask(with: url, completionHandler: completionHandler)
        return task as ImageSessionDataTaskProtocol
    }
}

extension URLSessionDataTask: ImageSessionDataTaskProtocol { }
