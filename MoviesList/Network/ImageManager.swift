//
//  ImageManager.swift
//  MoviesList
//
//  Created by Srinivasan Rajendran on 2020-04-13.
//  Copyright © 2020 Srinivasan Rajendran. All rights reserved.
//

import Foundation
import UIKit.UIImage
import Combine

final class ImageManager: ImageLoading {

    func loadImage(url: URL) -> AnyPublisher<UIImage?, Never> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { data, response -> UIImage? in return UIImage(data: data) }
            .catch { _ in Just(nil) }
            .eraseToAnyPublisher()
    }

}
