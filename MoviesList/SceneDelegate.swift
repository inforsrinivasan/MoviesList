//
//  SceneDelegate.swift
//  MoviesList
//
//  Created by Srinivasan Rajendran on 2020-04-12.
//  Copyright © 2020 Srinivasan Rajendran. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var mainCoordinator: MainCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        mainCoordinator = MainCoordinator(window: window)
        mainCoordinator?.start()
        self.window = window
        window.makeKeyAndVisible()
    }

}

