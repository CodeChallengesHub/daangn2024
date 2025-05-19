//
//  UIViewController+Error.swift
//  ITBook
//
//  Created by TAE SU LEE on 1/13/24.
//  Copyright © 2024 https://github.com/tsleedev. All rights reserved.
//

import UIKit

extension UIViewController {
    func showAlertForError(_ error: Error, completion: (() -> Void)? = nil) {
        showAlertForMessage(error.localizedDescription)
    }
    
    func showAlertForMessage(_ message: String, completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(
            title: "알림",
            message: message,
            preferredStyle: .alert
        )
        let confirmAction = UIAlertAction(title: "확인", style: .default) { _ in
            completion?()
        }
        alertController.addAction(confirmAction)
        present(alertController, animated: true)
    }
}
