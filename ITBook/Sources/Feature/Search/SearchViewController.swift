//
//  SearchViewController.swift
//  ITBook
//
//  Created by TAE SU LEE on 1/10/24.
//  Copyright © 2024 https://github.com/tsleedev. All rights reserved.
//

import UIKit
import Combine

class SearchViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, UITableViewDataSourcePrefetching {
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
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    // MARK: - Properties
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
        bind()
    }
}

// MARK: - Setup
private extension SearchViewController {
    /// Add subviews to the main view here.
    func setupViews() {
        view.addSubview(searchBar)
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        
        searchBar.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        tableView.prefetchDataSource = self
    }

    /// Define and activate the Auto Layout constraints for subviews here.
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

    /// Set initial values for other UI elements and handle localization.
    func configureUI() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "검색"
    }
    
    func bind() {
        viewModel.$items
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
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
            tableView.reloadData()
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

// MARK: - UITableViewDataSource
extension SearchViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier, for: indexPath) as! SearchTableViewCell
        cell.item = viewModel.items[indexPath.row]
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SearchViewController {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARL: - UITableViewDataSourcePrefetching
extension SearchViewController {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard viewModel.items.count > 0, viewModel.hasNextPage else { return }
        
        if indexPaths.contains(where: { $0.row >= viewModel.items.count - 1 }) {
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
        let searchClient = MockSearchClient()
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
