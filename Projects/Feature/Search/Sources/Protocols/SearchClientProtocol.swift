//
//  SearchClientProtocol.swift
//  ITBook
//
//  Created by TAE SU LEE on 1/10/24.
//  Copyright © 2024 https://github.com/tsleedev. All rights reserved.
//

import Foundation

protocol SearchClientProtocol {
    func search(keyword: String, page: Int) async throws -> SearchResult
}
