//
//  SearchItem.swift
//  ITBook
//
//  Created by TAE SU LEE on 1/10/24.
//  Copyright © 2024 https://github.com/tsleedev. All rights reserved.
//

import Foundation

struct SearchItem: Equatable, Hashable, Decodable {
    let id = UUID() // 각 인스턴스에 대한 고유 식별자, UUID를 사용하여 각 SearchItem이 고유함을 보장
    let title: String
    let subtitle: String
    let isbn13: String
    let price: String
    let image: String
    let url: String
    
    // Decodable 프로토콜을 준수하기 위한 CodingKeys
    // id는 서버에서 제공되지 않으므로 여기에서 제외 (Decodable이 id를 디코딩 과정에서 무시)
    private enum CodingKeys: String, CodingKey {
        case title, subtitle, isbn13, price, image, url
    }
}

#if DEBUG
extension SearchItem {
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
