//
//  SearchAPI.swift
//  ITBook
//
//  Created by TAE SU LEE on 1/11/24.
//  Copyright © 2024 https://github.com/tsleedev. All rights reserved.
//

import Foundation

enum SearchAPI: APIEndpointProtocol {
    case search(keyword: String, page: Int)
    case book(isbn13: String)

    var baseURL: URL {
        return URL(string: "https://api.itbook.store")!
    }

    var path: String {
        switch self {
        case .search(let keyword, let page):
            return "/1.0/search/\(keyword)/\(page)"
        case .book(let isbn13):
            return "/1.0/books/\(isbn13)"
        }
    }

    var method: APIMethod {
        switch self {
        case .search, .book:
            return .get
        }
    }

    var task: APITask {
        switch self {
        case .search, .book:
            return .requestPlain
        }
    }

    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}
