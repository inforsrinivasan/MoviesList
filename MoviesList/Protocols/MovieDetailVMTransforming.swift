//
//  MovieDetailVMTransforming.swift
//  MoviesList
//
//  Created by Srinivasan Rajendran on 2020-04-15.
//  Copyright © 2020 Srinivasan Rajendran. All rights reserved.
//

import Foundation
import Combine

struct MovieDetailVMInput {
    let appear: AnyPublisher<Void, Never>
}

enum MovieDetailState {
    case loading
    case success(MovieViewModel)
    case failure(Error)
}

typealias MovieDetailVMOutput = AnyPublisher<MovieDetailState, Never>

protocol MovieDetailVMTransforming {
    func transform(input: MovieDetailVMInput) -> MovieDetailVMOutput
}
