//
//  MoviesSearchViewModel.swift
//  MoviesList
//
//  Created by Srinivasan Rajendran on 2020-04-13.
//  Copyright © 2020 Srinivasan Rajendran. All rights reserved.
//

import Foundation
import UIKit.UIImage
import Combine

final class MoviesSearchViewModel: MoviesVMSearching {

    let moviesAPIManager: MoviesAPI

    init(moviesAPIManager: MoviesAPI) {
        self.moviesAPIManager = moviesAPIManager
    }

    func transform(input: MoviesVMSearchInput) -> MoviesVMSearchOutput {

        let searchInput = input.search
            .debounce(for: .microseconds(300), scheduler: Scheduler.mainScheduler, options: nil)
        .removeDuplicates()

        let movies = searchInput
            .filter { !$0.isEmpty }
            .map { [unowned self] query -> AnyPublisher<Result<[Movie], Error>, Never> in
                self.moviesAPIManager.searchMovies(name: query)
            }
            .switchToLatest()
            .map { result -> MoviesVMSearchState in
                switch result {
                case .success([]): return .noResults
                case .success(let movies): return .success(self.viewModels(from: movies))
                case .failure(let error): return .failure(error)
                }
            }
        .eraseToAnyPublisher()

        let initialState: MoviesVMSearchOutput = .just(.idle)
        let emptySearchString: MoviesVMSearchOutput = searchInput.filter({ $0.isEmpty }).map({ _ in .idle }).eraseToAnyPublisher()
        let idle: MoviesVMSearchOutput = Publishers.Merge(initialState, emptySearchString).eraseToAnyPublisher()

        return Publishers.Merge(idle, movies).removeDuplicates().eraseToAnyPublisher()
    }

    private func viewModels(from movies: [Movie]) -> [MovieViewModel] {
        return movies.map({[unowned self] movie in
            return self.viewModel(from: movie, imageLoader: {[unowned self] movie in self.moviesAPIManager.loadImage(for: movie, size: .small) })
        })
    }

    private func viewModel(from movie: Movie, imageLoader: (Movie) -> AnyPublisher<UIImage?, Never>) -> MovieViewModel {
        return MovieViewModel(id: movie.id,
                              title: movie.title,
                              subtitle: movie.subtitle,
                              overview: movie.overview,
                              poster: imageLoader(movie),
                              rating: String(format: "%.2f", movie.voteAverage))
    }
    
}
