//
//  Movies.swift
//  MoviesList
//
//  Created by Srinivasan Rajendran on 2020-04-13.
//  Copyright © 2020 Srinivasan Rajendran. All rights reserved.
//

import Foundation

struct Movies {
    let items: [Movie]
}

extension Movies: Decodable {

    enum CodingKeys: String, CodingKey {
        case items = "results"
    }
}
