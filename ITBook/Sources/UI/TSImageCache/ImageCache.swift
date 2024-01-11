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
    
    private var imageCache = NSCache<NSString, UIImage>()
    
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) -> ImageSessionDataTaskProtocol? {
        let cacheKey = NSString(string: url.absoluteString)
        
        if let cachedImage = imageCache.object(forKey: cacheKey) {
            completion(cachedImage)
            return nil
        }
        
        let task = session.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self, let data = data, error == nil else {
                completion(nil)
                return
            }
            if let image = UIImage(data: data) {
                self.imageCache.setObject(image, forKey: cacheKey)
                completion(image)
            } else {
                completion(nil)
            }
        }
        task.resume()
        return task
    }
}

#if DEBUG
extension ImageCache {
    func setSessionForTesting(session: ImageSessionProtocol) {
        self.session = session
    }
}
#endif
