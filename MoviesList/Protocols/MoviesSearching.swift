//
//  MoviesSearching.swift
//  MoviesList
//
//  Created by Srinivasan Rajendran on 2020-04-13.
//  Copyright © 2020 Srinivasan Rajendran. All rights reserved.
//

import Foundation
import Combine

struct MoviesVMSearchInput {
    let search: AnyPublisher<String, Never>
}

enum MoviesVMSearchState {
    case idle
    case loading
    case success([MovieViewModel])
    case noResults
    case failure(Error)
}

extension MoviesVMSearchState: Equatable {
    static func == (lhs: MoviesVMSearchState, rhs: MoviesVMSearchState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle): return true
        case (.loading, .loading): return true
        case (.success(let lhsMovies), .success(let rhsMovies)): return lhsMovies == rhsMovies
        case (.noResults, .noResults): return true
        case (.failure, .failure): return true
        default: return false
        }
    }
}

typealias MoviesVMSearchOutput = AnyPublisher<MoviesVMSearchState, Never>

protocol MoviesVMSearching {

    func transform(input: MoviesVMSearchInput) -> MoviesVMSearchOutput

}
