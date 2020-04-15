//
//  ServiceProvider.swift
//  MoviesList
//
//  Created by Srinivasan Rajendran on 2020-04-13.
//  Copyright © 2020 Srinivasan Rajendran. All rights reserved.
//

import Foundation

class ServiceProvider {

    let network: Networking
    let imageLoader: ImageLoading

    static func defaultProvider() -> ServiceProvider {
        let networkManager = NetworkManager()
        let imageManager = ImageManager()
        return ServiceProvider(network: networkManager, imageLoader: imageManager)
    }

    init(network: Networking, imageLoader: ImageLoading) {
        self.network = network
        self.imageLoader = imageLoader
    }

}
