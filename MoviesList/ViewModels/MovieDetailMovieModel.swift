//
//  MovieDetailMovieModel.swift
//  MoviesList
//
//  Created by Srinivasan Rajendran on 2020-04-15.
//  Copyright © 2020 Srinivasan Rajendran. All rights reserved.
//

import Foundation
import UIKit.UIImage
import Combine

class MovieDetailViewModel: MovieDetailVMTransforming {

    let moviesAPIManager: MoviesAPI
    let movieID: Int

    init(moviesAPIManager: MoviesAPI, movieID: Int) {
        self.moviesAPIManager = moviesAPIManager
        self.movieID = movieID
    }

    func transform(input: MovieDetailVMInput) -> MovieDetailVMOutput {
        let appear = input.appear
            .flatMap { [unowned self] _ in self.moviesAPIManager.movieDetails(with: self.movieID) }
            .map { result -> MovieDetailState in
                switch result {
                case .success(let movie):
                    return .success(self.viewModel(from: movie))
                case .failure(let error):
                    return .failure(error)
                }
        }
        .eraseToAnyPublisher()
        return appear
    }

    private func viewModel(from movie: Movie) -> MovieViewModel {
        return viewModel(from: movie, imageLoader: { [unowned self] movie in self.moviesAPIManager.loadImage(for: movie, size: .original)})
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
