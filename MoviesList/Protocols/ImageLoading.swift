//
//  ImageLoading.swift
//  MoviesList
//
//  Created by Srinivasan Rajendran on 2020-04-13.
//  Copyright © 2020 Srinivasan Rajendran. All rights reserved.
//

import UIKit
import Combine

protocol ImageLoading {
    func loadImage(url: URL) -> AnyPublisher<UIImage?, Never>
}
