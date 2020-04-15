//
//  MovieSearchCoordinator.swift
//  MoviesList
//
//  Created by Srinivasan Rajendran on 2020-04-12.
//  Copyright © 2020 Srinivasan Rajendran. All rights reserved.
//

import UIKit

final class MovieSearchCoordinator: Coordinating {

    var childCoordinators: [Coordinating]?
    let navigationController: UINavigationController
    let moviesAPIManager = MoviesAPIManager(serviceProvider: ServiceProvider.defaultProvider())

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let moviesSearchVM = MoviesSearchViewModel(moviesAPIManager: moviesAPIManager)
        let movieSearchVC = MoviesSearchViewController(viewModel: moviesSearchVM, navigating: self)
        navigationController.pushViewController(movieSearchVC, animated: true)
    }

}

extension MovieSearchCoordinator: MoviesSearchNavigating {

    func navigateToDetailScreen(movieID: Int) {
        let movieDetailViewModel = MovieDetailViewModel(moviesAPIManager: moviesAPIManager, movieID: movieID)
        let movieDetailsController = MoviesDetailViewController(viewModel: movieDetailViewModel)
        navigationController.pushViewController(movieDetailsController, animated: true)
    }
}
