//
//  BookClient.swift
//  ITBook
//
//  Created by TAE SU LEE on 1/11/24.
//  Copyright © 2024 https://github.com/tsleedev. All rights reserved.
//

import Foundation

protocol BookClient {
    func book(isbn13: String) async throws -> BookItem
}
