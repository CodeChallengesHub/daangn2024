//
//  ImageCache.swift
//  ITBook
//
//  Created by TAE SU LEE on 1/10/24.
//  Copyright © 2024 https://github.com/tsleedev. All rights reserved.
//

import UIKit

class ImageCache {
    static let shared = ImageCache()
    private var session: ImageSessionProtocol = URLSession.shared
    private var fileManager: ImageFileMangerProtocol = FileManager.default
    
    private var imageCache = NSCache<NSString, UIImage>()
    
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) -> ImageSessionDataTaskProtocol? {
        let cacheKey = NSString(string: url.absoluteString)
        
        // 메모리 캐시에서 이미지를 먼저 확인
        if let cachedImage = imageCache.object(forKey: cacheKey) {
            completion(cachedImage)
            return nil
        }
        
        // 디스크 캐시에서 이미지 확인
        if let diskCachedImage = loadImageFromDisk(withKey: url.absoluteString) {
            imageCache.setObject(diskCachedImage, forKey: cacheKey) // 메모리 캐시에도 저장
            completion(diskCachedImage)
            return nil
        }
        
        // 이미지를 네트워크에서 다운로드
        let task = session.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self, let data = data, error == nil else {
                completion(nil)
                return
            }
            if let image = UIImage(data: data) {
                self.imageCache.setObject(image, forKey: cacheKey) // 메모리 캐시에 저장
                self.saveImageToDisk(image, withKey: url.absoluteString) // 디스크에 저장
                completion(image)
            } else {
                completion(nil)
            }
        }
        task.resume()
        return task
    }
}

// MARK: - Disk Handling
private extension ImageCache {
    func loadImageFromDisk(withKey key: String) -> UIImage? {
        let filePath = getDiskCachePath(withKey: key)
        guard let data = fileManager.contents(atPath: filePath.path) else { return nil }
        return UIImage(data: data)
    }
    
    func saveImageToDisk(_ image: UIImage, withKey key: String) {
        guard let data = image.jpegData(compressionQuality: 1) ?? image.pngData() else { return }
        
        let filePath = getDiskCachePath(withKey: key)
        _ = fileManager.createFile(atPath: filePath.path, contents: data)
    }

    func getDiskCachePath(withKey key: String) -> URL {
        let cacheDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        return cacheDirectory.appendingPathComponent(key)
    }
}

#if DEBUG
extension ImageCache {
    func setSessionForTesting(session: ImageSessionProtocol) {
        self.session = session
    }
    
    func setFileManagerForTesting(fileManager: ImageFileMangerProtocol) {
        self.fileManager = fileManager
    }
    
    func getCachedImage(forKey key: String) -> UIImage? {
        return imageCache.object(forKey: NSString(string: key))
    }
}
#endif
