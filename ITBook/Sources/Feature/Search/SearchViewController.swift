//
//  SearchViewController.swift
//  ITBook
//
//  Created by TAE SU LEE on 1/10/24.
//  Copyright © 2024 https://github.com/tsleedev. All rights reserved.
//

import UIKit
import Combine

class SearchViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate {
    // MARK: - Views
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identifier)
        tableView.keyboardDismissMode = .onDrag
        tableView.separatorStyle = .none
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
    private let viewModel: SearchViewModel
    
    init(viewModel: SearchViewModel) {
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
private extension SearchViewController {
    /// Initialize and add subviews
    func setupViews() {
        view.addSubview(searchBar)
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        
        searchBar.delegate = self
        tableView.delegate = self
    }

    /// Set up Auto Layout constraints
    func setupConstraints() {
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
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
        navigationItem.title = "검색"
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
        
        viewModel.$items
            .receive(on: DispatchQueue.main)
            .sink { [weak self] items in
                self?.updateSnapshot(with: items)
            }
            .store(in: &cancellables)
        
        viewModel.$alertMessage
            .filter { $0 != nil }
            .map { $0! }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] message in
                self?.showAlertForMessage(message)
            }
            .store(in: &cancellables)
    }
}

// MARK: - UISearchBarDelegate
extension SearchViewController {
    // "검색" 버튼이 눌렸을 때의 처리 로직
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
        Task {
            await viewModel.search(keyword: searchText)
        }
    }
    
    // "X" 버튼이 눌렸을 때의 처리 로직
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            // "X" 버튼을 눌러 텍스트가 지워진 경우 또는 delete로 텍스트를 다 지운 경우
            viewModel.clearSearchResults()
        }
    }
}

// MARK: - UITableViewDiffableDataSource
extension SearchViewController {
    enum Section {
        case main
    }

    enum Row: Hashable {
        case item(SearchItem)
    }
    
    func setupDataSource() {
        dataSource = UITableViewDiffableDataSource<Section, Row>(tableView: tableView) { tableView, indexPath, row -> UITableViewCell? in
            switch row {
            case .item(let item):
                let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier, for: indexPath) as! SearchTableViewCell
                cell.configure(with: item)
                return cell
            }
        }
    }
    
    func updateSnapshot(with items: [SearchItem]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Row>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items.map { Row.item($0) }, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: - UITableViewDelegate
extension SearchViewController {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let item = viewModel.items[safe: indexPath.row] else { return }
        let bookClient = RealBookClient()
        let viewModel = BookViewModel(bookClient: bookClient, isbn13: item.isbn13)
        let destination = BookViewController(viewModel: viewModel)
        navigationController?.pushViewController(destination, animated: true)
    }
}

// MARL: - UIScrollViewDelegate
extension SearchViewController {
    // pagination 구현
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height
        
        if offsetY > contentHeight - frameHeight - 40 {
            guard viewModel.items.count > 0, viewModel.hasNextPage, !viewModel.isLoading else { return }
            Task {
                await viewModel.searchNextPage()
            }
        }
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct SearchViewController_Preview: PreviewProvider {
    static var previews: some View {
        var searchClient = MockSearchClient()
        searchClient.searchResults = [
            1: .mock1,
            2: .mock2
        ]
//        searchClient.error = NSError(domain: "TestError", code: 0, userInfo: nil)
        let viewModel = SearchViewModel(searchClient: searchClient)
        let viewController = SearchViewController(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: viewController)
        Task {
            await viewModel.search(keyword: "swift")
        }
        return navigationController.showPreview()
    }
}
#endif
