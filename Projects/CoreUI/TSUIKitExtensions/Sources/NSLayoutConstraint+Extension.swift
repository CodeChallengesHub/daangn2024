//
//  NSLayoutConstraint+Extension.swift
//  ITBook
//
//  Created by TAE SU LEE on 1/12/24.
//  Copyright © 2024 https://github.com/tsleedev. All rights reserved.
//

import UIKit

extension NSLayoutConstraint {
    func withPriority(_ priority: Float) -> NSLayoutConstraint {
        self.priority = UILayoutPriority(priority)
        return self
    }
}
