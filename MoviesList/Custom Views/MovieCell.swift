//
//  MovieCell.swift
//  MoviesList
//
//  Created by Srinivasan Rajendran on 2020-04-14.
//  Copyright © 2020 Srinivasan Rajendran. All rights reserved.
//

import UIKit
import Combine

class MovieCell: UITableViewCell {

    static let identifier = "movieCell"

    let movieImageView = UIImageView()
    let movieTitle = UILabel()
    let movieSubtitle = UILabel()
    let ratingImageView = UIImageView()
    let ratingLabel = UILabel()

    private var cancellable: AnyCancellable?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
        setConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bind(to viewModel: MovieViewModel) {
        cancelImageLoading()
        cancellable = viewModel.poster.sink { [unowned self] image in self.showImage(image: image)}
        movieTitle.text = viewModel.title
        movieSubtitle.text = viewModel.subtitle
        ratingLabel.text = viewModel.rating
    }

    private func showImage(image: UIImage?) {
        cancelImageLoading()
        UIView.transition(with: movieImageView, duration: 0.3, options: [.curveEaseOut, .transitionCrossDissolve], animations: {
            self.movieImageView.image = image
        }, completion: nil)
    }

    private func cancelImageLoading() {
        movieImageView.image = nil
        cancellable?.cancel()
    }

    private func configure() {
        addSubview(movieImageView)
        addSubview(movieTitle)
        addSubview(movieSubtitle)
        addSubview(ratingImageView)
        addSubview(ratingLabel)
        movieImageView.contentMode = .scaleAspectFit
        movieImageView.backgroundColor = .clear
        movieTitle.font = UIFont.systemFont(ofSize: 22, weight: .medium)
        movieSubtitle.font = UIFont.systemFont(ofSize: 16, weight: .thin)
        ratingImageView.image = UIImage(named: "star")
        ratingLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
    }

    private func setConstraints() {
        movieImageView.anchor(top: nil, leading: self.contentView.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 10, bottom: 0, right: 0), size: .init(width: 100, height: 100))
        movieImageView.centerYInSuperview()
        movieTitle.anchor(top: movieImageView.topAnchor, leading: movieImageView.trailingAnchor, bottom: nil, trailing: contentView.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 10), size: .init(width: 0, height: 0))
        movieSubtitle.anchor(top: movieTitle.bottomAnchor, leading: movieImageView.trailingAnchor, bottom: nil, trailing: contentView.trailingAnchor, padding: .init(top: 5, left: 0, bottom: 0, right: 10), size: .init(width: 0, height: 0))
        ratingImageView.anchor(top: nil, leading: movieImageView.trailingAnchor, bottom: movieImageView.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 20, height: 20))
        ratingLabel.centerYAnchor(anchor: ratingImageView.centerYAnchor)
        ratingLabel.anchor(top: nil, leading: ratingImageView.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 5, bottom: 0, right: 0), size: .init(width: 0, height: 0))
    }

}
