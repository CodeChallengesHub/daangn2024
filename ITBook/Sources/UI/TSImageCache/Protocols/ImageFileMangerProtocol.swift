//
//  ImageFileMangerProtocol.swift
//  ITBook
//
//  Created by TAE SU LEE on 1/14/24.
//  Copyright © 2024 https://github.com/tsleedev. All rights reserved.
//

import Foundation

protocol ImageFileMangerProtocol {
    func fileExists(atPath path: String) -> Bool
    func createFile(atPath path: String, contents data: Data?) -> Bool
    func contents(atPath path: String) -> Data?
    func urls(for directory: FileManager.SearchPathDirectory, in domainMask: FileManager.SearchPathDomainMask) -> [URL]
}

extension FileManager: ImageFileMangerProtocol {
    func createFile(atPath path: String, contents data: Data?) -> Bool {
        self.createFile(atPath: path, contents: data, attributes: nil)
    }
}
