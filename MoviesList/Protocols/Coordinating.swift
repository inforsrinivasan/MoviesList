//
//  Coordinating.swift
//  MoviesList
//
//  Created by Srinivasan Rajendran on 2020-04-12.
//  Copyright © 2020 Srinivasan Rajendran. All rights reserved.
//

import Foundation

protocol  Coordinating {
    func start()
    var childCoordinators: [Coordinating]? { get }
}

protocol MoviesSearchNavigating: class {
    func navigateToDetailScreen(movieID: Int)
}
