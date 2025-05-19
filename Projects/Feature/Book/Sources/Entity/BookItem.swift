//
//  BookItem.swift
//  ITBook
//
//  Created by TAE SU LEE on 1/11/24.
//  Copyright © 2024 https://github.com/tsleedev. All rights reserved.
//

import Foundation

struct BookItem: Decodable {
    let image: String
    let attributes: [BookAttribute]
    
    private enum CodingKeys: String, CodingKey, CaseIterable {
        case title, subtitle, authors, publisher, language, isbn10, isbn13, pages, year, rating, desc, price, image, url, pdf
    }
    
    init(image: String, attributes: [BookAttribute]) {
        self.image = image
        self.attributes = attributes
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        image = try container.decode(String.self, forKey: .image)
        
        var attributesTemp: [BookAttribute] = []
        
        // image와 제외한 나머지 키들에 대해서만 반복
        let remainingKeys = CodingKeys.allCases.filter { $0 != .image }
        for key in remainingKeys {
            if let value = try? container.decode(String.self, forKey: key) {
                attributesTemp.append(BookAttribute(key: key.rawValue, value: value))
            }
            else if key == .pdf, let pdfs = try? container.decode([String: String].self, forKey: .pdf) {
                var value: String = ""
                for (name, url) in pdfs {
                    if !value.isEmpty {
                        value += "\n\n"
                    }
                    value += "\(name)\n\(url)"
                }
                attributesTemp.append(BookAttribute(key: key.rawValue, value: value))
            }
        }
        
        attributes = attributesTemp
    }
}


struct BookAttribute: Hashable {
    let id = UUID()
    let key: String
    let value: String
}

#if DEBUG
extension BookItem {
    static let mock = Self(
        image: "https://itbook.store/img/books/9781617294136.png",
        attributes: [
            .init(key: "title",         value: "Securing DevOps"),
            .init(key: "subtitle",      value: "Security in the Cloud"),
            .init(key: "authors",       value: "Julien Vehent"),
            .init(key: "publisher",     value: "Manning"),
            .init(key: "language",      value: "English"),
            .init(key: "isbn10",        value: "1617294136"),
            .init(key: "isbn13",        value: "9781617294136"),
            .init(key: "pages",         value: "384"),
            .init(key: "year",          value: "2018"),
            .init(key: "rating",        value: "4"),
            .init(key: "desc",          value: "An application running in the cloud can benefit from incredible efficiencies..."),
            .init(key: "price",         value: "Julien Vehent"),
            .init(key: "url",           value: "https://itbook.store/books/9781617294136"),
            .init(key: "pdf",           value: """
                                            Chapter 2
                                            https://itbook.store/files/9781617294136/chapter2.pdf
                                            
                                            Chapter 5
                                            https://itbook.store/files/9781617294136/chapter5.pdf
                                            """),
        ]
    )
}
#endif
