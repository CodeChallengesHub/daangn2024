//
//  BookViewController.swift
//  ITBook
//
//  Created by TAE SU LEE on 1/11/24.
//  Copyright © 2024 https://github.com/tsleedev. All rights reserved.
//

import UIKit
import Combine

class BookViewController: UIViewController, UITableViewDelegate {
    // MARK: - Views
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(BookImageTableViewCell.self, forCellReuseIdentifier: BookImageTableViewCell.identifier)
        tableView.register(BookAttributeTableViewCell.self, forCellReuseIdentifier: BookAttributeTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    // MARK: - Properties
    private var dataSource: UITableViewDiffableDataSource<Section, Row>!
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialize with ViewModel
    private let viewModel: BookViewModel
    
    init(viewModel: BookViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupConstraints()
        configureUI()
        setupDataSource()
        observeViewModel()
    }
}

// MARK: - Setup
private extension BookViewController {
    /// Initialize and add subviews
    func setupViews() {
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        
        tableView.delegate = self
    }

    /// Set up Auto Layout constraints
    func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    /// Initialize UI elements and localization
    func configureUI() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "상세"
    }
    
    /// Observes ViewModel's published properties for updates.
    func observeViewModel() {
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.activityIndicator.startAnimating()
                } else {
                    self?.activityIndicator.stopAnimating()
                }
            }
            .store(in: &cancellables)
        
        viewModel.$item
            .receive(on: DispatchQueue.main)
            .sink { [weak self] item in
                self?.updateSnapshot(with: item)
            }
            .store(in: &cancellables)
        
        viewModel.$error
            .filter { $0 != nil }
            .map { $0! }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                self?.showAlertForError(error) {
                    self?.navigationController?.popViewController(animated: true)
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - UITableViewDiffableDataSource
extension BookViewController {
    enum Section {
        case main
        case detail
    }

    enum Row: Hashable {
        case image(String)
        case attribute(BookAttribute)
    }
    
    func setupDataSource() {
        dataSource = UITableViewDiffableDataSource<Section, Row>(tableView: tableView) { tableView, indexPath, row -> UITableViewCell? in
            switch row {
            case .image(let imageUrl):
                let cell = tableView.dequeueReusableCell(withIdentifier: BookImageTableViewCell.identifier, for: indexPath) as! BookImageTableViewCell
                cell.configure(with: imageUrl)
                return cell
                
            case .attribute(let attribute):
                let cell = tableView.dequeueReusableCell(withIdentifier: BookAttributeTableViewCell.identifier, for: indexPath) as! BookAttributeTableViewCell
                cell.configure(with: attribute)
                return cell
            }
        }
    }
    
    func updateSnapshot(with item: BookItem?) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Row>()
        snapshot.appendSections([.main, .detail])
        
        if let item = item {
            snapshot.appendItems([.image(item.image)], toSection: .main)
            let attributes = item.attributes.map { Row.attribute($0) }
            snapshot.appendItems(attributes, toSection: .detail)
        }
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

// MARK: - UITableViewDelegate
extension BookViewController {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct BookViewController_Preview: PreviewProvider {
    static var previews: some View {
        var bookClient = MockBookClient()
        bookClient.bookItem = .mock
//        bookClient.error = NSError(domain: "TestError", code: 0, userInfo: nil)
        let viewModel = BookViewModel(bookClient: bookClient, isbn13: "1234")
        let viewController = BookViewController(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: viewController)
        return navigationController.showPreview()
    }
}
#endif
