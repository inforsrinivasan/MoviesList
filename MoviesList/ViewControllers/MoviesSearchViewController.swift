//
//  MoviesSearchViewController.swift
//  MoviesList
//
//  Created by Srinivasan Rajendran on 2020-04-12.
//  Copyright © 2020 Srinivasan Rajendran. All rights reserved.
//

import UIKit
import Combine

class MoviesSearchViewController: UIViewController {

    let viewModel: MoviesVMSearching
    private var cancellables: [AnyCancellable] = []
    private let search = PassthroughSubject<String, Never>()
    let tableView = UITableView(frame: .zero, style: .plain)
    let navigating: MoviesSearchNavigating

    private lazy var dataSource = makeDataSource()

    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.tintColor = UIColor.black
        searchController.searchBar.delegate = self
        return searchController
    }()

    init(viewModel: MoviesVMSearching, navigating: MoviesSearchNavigating) {
        self.viewModel = viewModel
        self.navigating = navigating
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Top Movies"
        view.backgroundColor = .systemBackground
        configureSearchController()
        configureTableView()
        setBindings()
    }

    private func configureSearchController() {
        definesPresentationContext = true
        navigationItem.searchController = searchController
        searchController.isActive = true
    }

    private func configureTableView() {
        view.addSubview(tableView)
        tableView.register(MovieCell.self, forCellReuseIdentifier: MovieCell.identifier)
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: .zero, size: .zero)
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = dataSource
    }

    private func render(_ state: MoviesVMSearchState) {
        removeIdleState(in: view)
        update(with: [], animate: true)
        switch state {
        case .idle:
            showIdleState(message: "Search for a movie...", in: view)
        case .loading:
            print("loading")
        case .noResults:
            print("no results")
        case .failure:
            print("failure")
        case .success(let movies):
            update(with: movies, animate: true)
        }
    }

    private func setBindings() {

        let input = MoviesVMSearchInput(search: search.eraseToAnyPublisher())
        let output = viewModel.transform(input: input)
        output.sink { [weak self] state in
            self?.render(state)
        }.store(in: &cancellables)
    }
}

extension MoviesSearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        search.send(searchText)
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        search.send("")
    }
}

extension MoviesSearchViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        guard let movieID = dataSource.itemIdentifier(for: indexPath)?.id else { return }
        navigating.navigateToDetailScreen(movieID: movieID)
    }
}

extension MoviesSearchViewController {

    enum Section: CaseIterable {
        case movies
    }

    func makeDataSource() -> UITableViewDiffableDataSource<Section, MovieViewModel>{
        return UITableViewDiffableDataSource(tableView: self.tableView) { tableView, indexPath, movieViewModel in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieCell.identifier) as? MovieCell else {
                return UITableViewCell()
            }
            cell.bind(to: movieViewModel)
            return cell
        }
    }

    func update(with movies: [MovieViewModel], animate: Bool = true) {
        DispatchQueue.main.async {
            var snapshot = NSDiffableDataSourceSnapshot<Section, MovieViewModel>()
            snapshot.appendSections(Section.allCases)
            snapshot.appendItems(movies, toSection: .movies)
            self.dataSource.apply(snapshot, animatingDifferences: animate)
        }
    }
}
