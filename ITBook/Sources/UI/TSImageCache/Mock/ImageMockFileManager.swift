//
//  ImageMockFileManager.swift
//  ITBook
//
//  Created by TAE SU LEE on 1/14/24.
//  Copyright © 2024 https://github.com/tsleedev. All rights reserved.
//

import Foundation

class ImageMockFileManager: ImageFileMangerProtocol {
    var files = [String: Data]()

    func fileExists(atPath path: String) -> Bool {
        return files[path] != nil
    }

    func createFile(atPath path: String, contents data: Data?) -> Bool {
        files[path] = data
        return true
    }

    func contents(atPath path: String) -> Data? {
        return files[path]
    }
    
    func urls(for directory: FileManager.SearchPathDirectory, in domainMask: FileManager.SearchPathDomainMask) -> [URL] {
        // 테스트를 위한 임시 디렉토리 URL 반환
        let temporaryDirectoryPath = NSTemporaryDirectory()
        let temporaryDirectoryURL = URL(fileURLWithPath: temporaryDirectoryPath)
        return [temporaryDirectoryURL]
    }
}
