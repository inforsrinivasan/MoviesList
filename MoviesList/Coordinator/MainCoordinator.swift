//
//  MainCoordinator.swift
//  MoviesList
//
//  Created by Srinivasan Rajendran on 2020-04-12.
//  Copyright © 2020 Srinivasan Rajendran. All rights reserved.
//

import UIKit

final class MainCoordinator: Coordinating {

    var childCoordinators: [Coordinating]?
    let window: UIWindow

    init(window: UIWindow) {
        self.window = window
        childCoordinators = []
    }

    func start() {
        let navigationController = UINavigationController()
        navigationController.navigationBar.tintColor = .red
        window.rootViewController = navigationController
        // Movie search coordinator
        let movieSearchCoordinator = MovieSearchCoordinator(navigationController: navigationController)
        childCoordinators?.append(movieSearchCoordinator)
        movieSearchCoordinator.start()
    }

}
