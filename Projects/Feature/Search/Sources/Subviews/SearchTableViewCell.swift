//
//  SearchTableViewCell.swift
//  ITBook
//
//  Created by TAE SU LEE on 1/10/24.
//  Copyright © 2024 https://github.com/tsleedev. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    private enum ImageSize { // 이미지 300x350 비율에 맞춤
        static let width: CGFloat = 60
        static let height: CGFloat = 70
    }
    
    // MARK: - Views
    private let bookImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: ImageSize.width, height: ImageSize.height))
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 1.0
        imageView.layer.borderColor = UIColor.systemGray3.cgColor
        imageView.contentMode = .scaleAspectFit
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
        bookImageView.cancelImageLoad()
        bookImageView.image = nil
        titleLabel.text = nil
        subtitleLabel.text = nil
        priceLabel.text = nil
    }
    
    func configure(with item: SearchItem?) {
        bookImageView.setImage(with: item?.image)
        titleLabel.text = item?.title
        subtitleLabel.text = item?.subtitle
        priceLabel.text = item?.price
    }
}

// MARK: - Setup
private extension SearchTableViewCell {
    /// Initialize and add subviews
    func setupViews() {
        contentView.addSubview(bookImageView)
        contentView.addSubview(stackView)
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subtitleLabel)
        stackView.addArrangedSubview(priceLabel)
    }
    
    /// Set up Auto Layout constraints
    func setupConstraints() {
        NSLayoutConstraint.activate([
            bookImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            bookImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            bookImageView.widthAnchor.constraint(equalToConstant: ImageSize.width),
            bookImageView.heightAnchor.constraint(equalToConstant: ImageSize.height)
        ])
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(lessThanOrEqualTo: contentView.topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: bookImageView.trailingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -10),
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    /// Initialize UI elements and localization
    func configureUI() {
        accessoryType = .disclosureIndicator
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct SearchTableViewCell_Preview: PreviewProvider {
    static var previews: some View {
        let cell = SearchTableViewCell(style: .default, reuseIdentifier: "cellID")
        cell.configure(with: .mock)
        return cell.showPreview()
            .previewLayout(.fixed(width: 320, height: 100))
    }
}
#endif
