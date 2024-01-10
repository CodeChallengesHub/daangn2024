//
//  SearchViewController.swift
//  ITBook
//
//  Created by TAE SU LEE on 1/10/24.
//  Copyright © 2024 https://github.com/tsleedev. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupConstraints()
        configureUI()
        observeFeatureState()
    }
}

// MARK: - Setup
private extension SearchViewController {
    /// Add subviews to the main view here.
    func setupViews() {
        
    }

    /// Define and activate the Auto Layout constraints for subviews here.
    func setupConstraints() {
        
    }

    /// Set initial values for other UI elements and handle localization.
    func configureUI() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "검색"
    }

    /// Observes changes in the feature's state and updates the UI accordingly.
    func observeFeatureState() {
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct SearchViewController_Preview: PreviewProvider {
    static var previews: some View {
        return SearchViewController().showPreview()
    }
}
#endif
