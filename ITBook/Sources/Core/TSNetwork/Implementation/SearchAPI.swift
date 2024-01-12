//
//  SearchAPI.swift
//  ITBook
//
//  Created by TAE SU LEE on 1/11/24.
//  Copyright © 2024 https://github.com/tsleedev. All rights reserved.
//

import Foundation

enum SearchAPI: APIEndpoint {
    case search(keyword: String, page: Int)

    var baseURL: URL {
        return URL(string: "https://api.itbook.store/1.0")!
    }

    var path: String {
        switch self {
        case .search(let keyword, let page):
            return "/search/\(keyword)/\(page)"
        }
    }

    var method: APIMethod {
        switch self {
        case .search:
            return .get
        }
    }

    var task: APITask {
        switch self {
        case .search:
            return .requestPlain
        }
    }

    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}
