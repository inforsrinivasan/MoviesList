//
//  IdleStateView.swift
//  MoviesList
//
//  Created by Srinivasan Rajendran on 2020-04-15.
//  Copyright © 2020 Srinivasan Rajendran. All rights reserved.
//

import UIKit

class IdleStateView: UIView {

    let messageLabel = UILabel()
    let emptyImageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    convenience init(message: String, frame: CGRect) {
        self.init(frame: frame)
        messageLabel.text = message
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        setUpImageView()
        setUpLabel()
    }

    private func setUpLabel() {
        addSubview(messageLabel)
        messageLabel.anchor(top: emptyImageView.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 10, left: 20, bottom: 0, right: 20), size: .init(width: 0, height: 50))
        messageLabel.numberOfLines = 3
        messageLabel.textColor = .darkGray
        messageLabel.textAlignment = .center
    }

    private func setUpImageView() {
        addSubview(emptyImageView)
        emptyImageView.centerInSuperview()
        emptyImageView.anchor(top: nil, leading: nil, bottom: nil, trailing: nil, padding: .zero, size: .init(width: 50, height: 50))
        emptyImageView.image = UIImage(named: "search")
    }
}

