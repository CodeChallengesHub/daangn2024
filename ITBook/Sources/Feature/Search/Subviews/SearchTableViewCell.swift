//
//  SearchTableViewCell.swift
//  ITBook
//
//  Created by TAE SU LEE on 1/10/24.
//  Copyright © 2024 https://github.com/tsleedev. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    private enum ImageSize { // 이미지 300x350라 비율에 맞춤
        static let width: CGFloat = 60
        static let height: CGFloat = 70
    }
    
    // MARK: - Views
    private let iconImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: ImageSize.width, height: ImageSize.height))
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 1.0
        imageView.layer.borderColor = UIColor.systemGray3.cgColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15.0, weight: .semibold)
        label.text = "title"
        label.textColor = .label
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15.0, weight: .regular)
        label.text = "subtitle"
        label.textColor = .label
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15.0, weight: .regular)
        label.text = "price"
        label.textColor = .label
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()

    // MARK: - Properties
    var item: BookItem? {
        didSet {
            updateUI()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
        configureUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    private func updateUI() {
        iconImageView.image = UIImage()
        titleLabel.text = item?.title
        subtitleLabel.text = item?.subtitle
        priceLabel.text = item?.price
    }
}

// MARK: - Setup
private extension SearchTableViewCell {
    /// Add subviews to the main view here.
    func setupViews() {
        contentView.addSubview(iconImageView)
        contentView.addSubview(stackView)
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subtitleLabel)
        stackView.addArrangedSubview(priceLabel)
    }
    
    /// Define and activate the Auto Layout constraints for subviews here.
    func setupConstraints() {
        NSLayoutConstraint.activate([
            iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            iconImageView.widthAnchor.constraint(equalToConstant: ImageSize.width),
            iconImageView.heightAnchor.constraint(equalToConstant: ImageSize.height)
        ])
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(lessThanOrEqualTo: contentView.topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -10),
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    /// Set initial values for other UI elements and handle localization.
    func configureUI() {
        accessoryType = .disclosureIndicator
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct SearchTableViewCell_Preview: PreviewProvider {
    static var previews: some View {
        let cell = SearchTableViewCell(style: .default, reuseIdentifier: "cellID")
        cell.item = .mock
        return cell.showPreview()
            .previewLayout(.fixed(width: 320, height: 100))
    }
}
#endif
