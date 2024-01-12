//
//  SearchResult.swift
//  ITBook
//
//  Created by TAE SU LEE on 1/10/24.
//  Copyright © 2024 https://github.com/tsleedev. All rights reserved.
//

import Foundation

struct SearchResult: Decodable {
    let total: Int
    let page: Int
    let books: [BookItem]
    
    enum CodingKeys: String, CodingKey {
        case total, page, books
    }
    
    init(total: Int, page: Int, books: [BookItem]) {
        self.total = total
        self.page = page
        self.books = books
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let totalString = try container.decode(String.self, forKey: .total)
        guard let totalInt = Int(totalString) else {
            throw DecodingError.dataCorruptedError(forKey: .total, in: container, debugDescription: "Total is not an integer")
        }
        self.total = totalInt
        let pageString = try container.decode(String.self, forKey: .page)
        guard let pageInt = Int(pageString) else {
            throw DecodingError.dataCorruptedError(forKey: .total, in: container, debugDescription: "Page is not an integer")
        }
        self.page = pageInt
        self.books = try container.decode([BookItem].self, forKey: .books)
    }
}

extension SearchResult {
    static let mock1 = Self(
        total: 19,
        page: 1,
        books: [
            .init(
                title: "Learning Swift 2 Programming, 2nd Edition",
                subtitle: "",
                isbn13: "9780134431598",
                price: "$28.32",
                image: "https://itbook.store/img/books/9780134431598.png",
                url: "https://itbook.store/books/9780134431598"
            ),
            .init(
                title: "A Swift Kickstart, 2nd Edition",
                subtitle: "Introducing the Swift Programming Language",
                isbn13: "9780983066989",
                price: "$29.99",
                image: "https://itbook.store/img/books/9780983066989.png",
                url: "https://itbook.store/books/9780983066989"
            ),
            .init(
                title: "iOS 15 Programming Fundamentals with Swift",
                subtitle: "Swift, Xcode, and Cocoa Basics",
                isbn13: "9781098118501",
                price: "$53.44",
                image: "https://itbook.store/img/books/9781098118501.png",
                url: "https://itbook.store/books/9781098118501"
            ),
            .init(
                title: "Swift For Dummies",
                subtitle: "",
                isbn13: "9781119022220",
                price: "$21.03",
                image: "https://itbook.store/img/books/9781119022220.png",
                url: "https://itbook.store/books/9781119022220"
            ),
            .init(
                title: "Transitioning to Swift",
                subtitle: "",
                isbn13: "9781484204078",
                price: "$25.84",
                image: "https://itbook.store/img/books/9781484204078.png",
                url: "https://itbook.store/books/9781484204078"
            ),
            .init(
                title: "Beginning iPhone Development with Swift 2, 2nd Edition",
                subtitle: "Exploring the iOS 9 SDK",
                isbn13: "9781484217535",
                price: "$25.00",
                image: "https://itbook.store/img/books/9781484217535.png",
                url: "https://itbook.store/books/9781484217535"
            ),
            .init(
                title: "OS X App Development with CloudKit and Swift",
                subtitle: "",
                isbn13: "9781484218792",
                price: "$37.87",
                image: "https://itbook.store/img/books/9781484218792.png",
                url: "https://itbook.store/books/9781484218792"
            ),
            .init(
                title: "Learn Computer Science with Swift",
                subtitle: "Computation Concepts, Programming Paradigms, Data Management, and Modern Component Architectures with Swift and Playgrounds",
                isbn13: "9781484230657",
                price: "$17.23",
                image: "https://itbook.store/img/books/9781484230657.png",
                url: "https://itbook.store/books/9781484230657"
            ),
            .init(
                title: "Deep Learning with Swift for TensorFlow",
                subtitle: "Differentiable Programming with Swift",
                isbn13: "9781484263297",
                price: "$39.13",
                image: "https://itbook.store/img/books/9781484263297.png",
                url: "https://itbook.store/books/9781484263297"
            ),
            .init(
                title: "OpenStack Swift",
                subtitle: "Using, Administering, and Developing for Swift Object Storage",
                isbn13: "9781491900826",
                price: "$5.31",
                image: "https://itbook.store/img/books/9781491900826.png",
                url: "https://itbook.store/books/9781491900826"
            )
        ]
    )
    
    static let mock2 = Self(
        total: 19,
        page: 2,
        books: [
            .init(
                title: "iOS 8 Programming Fundamentals with Swift",
                subtitle: "Swift, Xcode, and Cocoa Basics",
                isbn13: "9781491908907",
                price: "$3.65",
                image: "https://itbook.store/img/books/9781491908907.png",
                url: "https://itbook.store/books/9781491908907"
            ),
            .init(
                title: "iOS 9 Programming Fundamentals with Swift",
                subtitle: "Swift, Xcode, and Cocoa Basics",
                isbn13: "9781491936771",
                price: "$4.25",
                image: "https://itbook.store/img/books/9781491936771.png",
                url: "https://itbook.store/books/9781491936771"
            ),
            .init(
                title: "Learning Swift, 3rd Edition",
                subtitle: "Building Apps for macOS, iOS, and Beyond",
                isbn13: "9781491987575",
                price: "$33.92",
                image: "https://itbook.store/img/books/9781491987575.png",
                url: "https://itbook.store/books/9781491987575"
            ),
            .init(
                title: "iOS 11 Programming Fundamentals with Swift",
                subtitle: "Swift, Xcode, and Cocoa Basics",
                isbn13: "9781491999318",
                price: "$23.03",
                image: "https://itbook.store/img/books/9781491999318.png",
                url: "https://itbook.store/books/9781491999318"
            ),
            .init(
                title: "iOS 12 Programming Fundamentals with Swift",
                subtitle: "Swift, Xcode, and Cocoa Basics",
                isbn13: "9781492044550",
                price: "$56.99",
                image: "https://itbook.store/img/books/9781492044550.png",
                url: "https://itbook.store/books/9781492044550"
            ),
            .init(
                title: "iOS 14 Programming Fundamentals with Swift",
                subtitle: "Swift, Xcode, and Cocoa Basics",
                isbn13: "9781492092094",
                price: "$41.20",
                image: "https://itbook.store/img/books/9781492092094.png",
                url: "https://itbook.store/books/9781492092094"
            ),
            .init(
                title: "Implementing Cloud Storage with OpenStack Swift",
                subtitle: "Design, implement, and successfully manage your own cloud storage cluster using the popular OpenStack Swift software",
                isbn13: "9781782168058",
                price: "$23.99",
                image: "https://itbook.store/img/books/9781782168058.png",
                url: "https://itbook.store/books/9781782168058"
            ),
            .init(
                title: "Game Development with Swift",
                subtitle: "Embrace the mobile gaming revolution and bring your iPhone game ideas to life with Swift",
                isbn13: "9781783550531",
                price: "$39.99",
                image: "https://itbook.store/img/books/9781783550531.png",
                url: "https://itbook.store/books/9781783550531"
            ),
            .init(
                title: "Swift 2 Blueprints",
                subtitle: "Sharpen your skills in Swift by designing and deploying seven fully functional applications",
                isbn13: "9781783980765",
                price: "$46.65",
                image: "https://itbook.store/img/books/9781783980765.png",
                url: "https://itbook.store/books/9781783980765"
            )
        ]
    )
}
