//
//  UIViewController+IdleStateView.swift
//  MoviesList
//
//  Created by Srinivasan Rajendran on 2020-04-15.
//  Copyright © 2020 Srinivasan Rajendran. All rights reserved.
//

import UIKit

extension UIViewController {

    func showIdleState(message: String, in view: UIView) {
        let idleStateView = IdleStateView(message: message, frame: view.bounds)
        if view.subviews.contains(idleStateView) {
            view.bringSubviewToFront(idleStateView)
        } else {
            view.addSubview(idleStateView)
        }
    }

    func removeIdleState(in view: UIView) {
        view.subviews.forEach { subView in
            if subView is IdleStateView {
                subView.removeFromSuperview()
            }
        }
    }

}
