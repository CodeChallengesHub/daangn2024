//
//  BookImageTableViewCell.swift
//  ITBook
//
//  Created by TAE SU LEE on 1/12/24.
//  Copyright © 2024 https://github.com/tsleedev. All rights reserved.
//

import UIKit

class BookImageTableViewCell: UITableViewCell {
    // MARK: - Views
    private let bookImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
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
        bookImageView.image = nil
    }
    
    func configure(with imageUrl: String?) {
        bookImageView.setImage(with: imageUrl)
    }
}

// MARK: - Setup
private extension BookImageTableViewCell {
    /// Initialize and add subviews
    func setupViews() {
        contentView.addSubview(bookImageView)
    }
    
    /// Set up Auto Layout constraints
    func setupConstraints() {
        NSLayoutConstraint.activate([
            bookImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            bookImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            bookImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            bookImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            bookImageView.heightAnchor.constraint(equalToConstant: 200).withPriority(750)
        ])
    }
    
    /// Initialize UI elements and localization
    func configureUI() {
        selectionStyle = .none
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct BookImageTableViewCell_Preview: PreviewProvider {
    static var previews: some View {
        let cell = BookImageTableViewCell(style: .default, reuseIdentifier: "cellID")
        cell.configure(with: "https://itbook.store/img/books/9781617294136.png")
        return cell.showPreview()
            .previewLayout(.fixed(width: 320, height: 200))
    }
}
#endif
