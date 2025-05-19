//
//  UIImageView+Download.swift
//  ITBook
//
//  Created by TAE SU LEE on 1/11/24.
//  Copyright © 2024 https://github.com/tsleedev. All rights reserved.
//

import UIKit

extension UIImageView {
    private struct AssociatedKeys {
        static var currentTaskKey: UInt8 = 0
        static var currentURLKey: UInt8 = 0
    }

    private var currentURL: URL? {
        get { return objc_getAssociatedObject(self, &AssociatedKeys.currentURLKey) as? URL }
        set { objc_setAssociatedObject(self, &AssociatedKeys.currentURLKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    private var task: ImageSessionDataTaskProtocol? {
        get { return objc_getAssociatedObject(self, &AssociatedKeys.currentTaskKey) as? ImageSessionDataTaskProtocol }
        set { objc_setAssociatedObject(self, &AssociatedKeys.currentTaskKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    func cancelImageLoad() {
        task?.cancel()
        task = nil
        currentURL = nil
    }
    
    func setImage(with urlString: String?) {
        guard let urlString = urlString, let url = URL(string: urlString) else {
            cancelImageLoad()
            return
        }
        setImage(with: url)
    }

    func setImage(with url: URL) {
        cancelImageLoad()
        currentURL = url

        task = ImageCache.shared.loadImage(from: url) { [weak self] image in
            DispatchQueue.main.async {
                // 현재 이미지 뷰가 같은 URL의 이미지를 기다리고 있는지 확인
                if self?.currentURL == url, let image = image {
                    self?.image = image
                }
            }
        }
    }
}
