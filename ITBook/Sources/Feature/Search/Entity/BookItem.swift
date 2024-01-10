//
//  SearchItem.swift
//  ITBook
//
//  Created by TAE SU LEE on 1/10/24.
//  Copyright © 2024 https://github.com/tsleedev. All rights reserved.
//

import Foundation

struct BookItem: Equatable {
    let title: String
    let subtitle: String
    let isbn13: String
    let price: String
    let image: String
    let url: String
}

#if DEBUG
extension BookItem {
    static let mock = Self(
        title: "A Swift Kickstart, 2nd Edition",
        subtitle: "Introducing the Swift Programming Language",
        isbn13: "9780983066989",
        price: "$29.99",
        image: "https://itbook.store/img/books/9780983066989.png",
        url: "https://itbook.store/books/9780983066989"
    )
}
#endif
