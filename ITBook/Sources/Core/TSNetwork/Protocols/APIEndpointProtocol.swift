//
//  APIEndpointProtocol.swift
//  ITBook
//
//  Created by TAE SU LEE on 1/11/24.
//  Copyright © 2024 https://github.com/tsleedev. All rights reserved.
//

import Foundation

protocol APIEndpointProtocol {
    var baseURL: URL { get }
    var path: String { get }
    var method: APIMethod { get }
    var task: APITask { get }
    var headers: [String: String]? { get }
}

enum APIMethod: String {
    case get = "GET"
    case post = "POST"
    case patch = "PATCH"
    case put = "PUT"
}

enum APITask {
    case requestPlain
    case requestData(Data)
    case requestParameters([String: Any])
}
