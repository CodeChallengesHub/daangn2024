//
//  BookAttributeTableViewCell.swift
//  ITBook
//
//  Created by TAE SU LEE on 1/11/24.
//  Copyright © 2024 https://github.com/tsleedev. All rights reserved.
//

import UIKit

class BookAttributeTableViewCell: UITableViewCell {
    // MARK: - Views
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.distribution = .fill
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let attributeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15.0, weight: .regular)
        label.text = "attribute"
        label.textColor = .label
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var linkableTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 14.0, weight: .regular)
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.dataDetectorTypes = .link
        textView.textContainerInset = UIEdgeInsets.zero
        textView.textContainer.lineFragmentPadding = 0
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
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
        attributeLabel.text = nil
        linkableTextView.text = nil
    }
    
    func configure(with attritube: BookAttribute?) {
        attributeLabel.text = attritube?.key
        linkableTextView.text = attritube?.value
    }
}

// MARK: - Setup
private extension BookAttributeTableViewCell {
    /// Initialize and add subviews
    func setupViews() {
        contentView.addSubview(stackView)
        
        stackView.addArrangedSubview(attributeLabel)
        stackView.addArrangedSubview(linkableTextView)
    }
    
    /// Set up Auto Layout constraints
    func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            
            attributeLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 1/4).withPriority(750),
            linkableTextView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 3/4)
        ])
    }
    
    /// Initialize UI elements and localization
    func configureUI() {
        selectionStyle = .none
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct BookAttributeTableViewCell_Preview: PreviewProvider {
    static var previews: some View {
        let cell = BookAttributeTableViewCell(style: .default, reuseIdentifier: "cellID")
        cell.configure(with: .init(key: "desc", value: "An application running in the cloud can benefit from incredible efficiencies..."))
        return cell.showPreview()
            .previewLayout(.fixed(width: 320, height: 100))
    }
}
#endif
