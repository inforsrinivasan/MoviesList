//
//  MoviesAPI.swift
//  MoviesList
//
//  Created by Srinivasan Rajendran on 2020-04-13.
//  Copyright © 2020 Srinivasan Rajendran. All rights reserved.
//

import Foundation
import UIKit.UIImage
import Combine

protocol MoviesAPI {
    func searchMovies(name: String) -> AnyPublisher<Result<[Movie], Error>, Never>
    func loadImage(for movie: Movie, size: ImageSize) -> AnyPublisher<UIImage?, Never>
    func movieDetails(with id: Int) -> AnyPublisher<Result<Movie, Error>, Never>
}

final class MoviesAPIManager: MoviesAPI {

    let serviceProvider: ServiceProvider

    init(serviceProvider: ServiceProvider) {
        self.serviceProvider = serviceProvider
    }

    func searchMovies(name: String) -> AnyPublisher<Result<[Movie], Error>, Never> {
        return serviceProvider.network
            .load(resource: Resource<Movies>.movies(query: name))
            .map { result -> Result<[Movie],Error> in
                switch result {
                case .success(let movies): return .success(movies.items)
                case .failure(let error): return .failure(error)
                }
            }
        .subscribe(on: Scheduler.backgroundWorkScheduler)
        .receive(on: Scheduler.mainScheduler)
        .eraseToAnyPublisher()
    }

    func loadImage(for movie: Movie, size: ImageSize) -> AnyPublisher<UIImage?, Never> {
        return Deferred { return Just(movie.poster) }
        .flatMap({[unowned self] poster -> AnyPublisher<UIImage?, Never> in
            guard let poster = movie.poster else { return .just(nil) }
            let url = size.url.appendingPathComponent(poster)
            return self.serviceProvider.imageLoader.loadImage(url: url)
        })
        .subscribe(on: Scheduler.backgroundWorkScheduler)
        .receive(on: Scheduler.mainScheduler)
        .share()
        .eraseToAnyPublisher()
    }

    func movieDetails(with id: Int) -> AnyPublisher<Result<Movie, Error>, Never> {
        return serviceProvider.network
            .load(resource: Resource<Movie>.details(movieId: id))
            .map({ (result: Result<Movie, NetworkError>) -> Result<Movie, Error> in
                switch result {
                case .success(let movie): return .success(movie)
                case .failure(let error): return .failure(error)
                }
            })
            .subscribe(on: Scheduler.backgroundWorkScheduler)
            .receive(on: Scheduler.mainScheduler)
            .eraseToAnyPublisher()
    }

}

final class Scheduler {

    static var backgroundWorkScheduler: OperationQueue = {
        let operationQueue = OperationQueue()
        operationQueue.maxConcurrentOperationCount = 5
        operationQueue.qualityOfService = QualityOfService.userInitiated
        return operationQueue
    }()

    static let mainScheduler = RunLoop.main

}

enum ImageSize {
    case small
    case original
    var url: URL {
        switch self {
        case .small: return ApiConstants.smallImageUrl
        case .original: return ApiConstants.originalImageUrl
        }
    }
}
