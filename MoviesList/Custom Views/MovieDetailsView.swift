//
//  MovieDetailsView.swift
//  MoviesList
//
//  Created by Srinivasan Rajendran on 2020-04-15.
//  Copyright © 2020 Srinivasan Rajendran. All rights reserved.
//

import UIKit
import Combine

class MovieDetailsView: UIView {

    let movieImageView = UIImageView()
    let movieTitle = UILabel()
    let movieSubtitle = UILabel()
    let movieDescription = UILabel()
    private var cancellable: AnyCancellable?

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
        setUpConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureViews() {
        backgroundColor = .white
        addSubview(movieImageView)
        addSubview(movieTitle)
        addSubview(movieSubtitle)
        addSubview(movieDescription)
        movieImageView.contentMode = .scaleToFill
        movieImageView.backgroundColor = .clear
        movieTitle.font = UIFont.systemFont(ofSize: 22, weight: .medium)
        movieSubtitle.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        movieDescription.font = UIFont.systemFont(ofSize: 20, weight: .thin)
        movieDescription.numberOfLines = 0
    }

    private func setUpConstraints() {
        movieImageView.anchor(top: safeAreaLayoutGuide.topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .zero, size: .init(width: 0, height: 500))
        movieTitle.anchor(top: movieImageView.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 10, left: 10, bottom: 0, right: 10), size: .zero)
        movieSubtitle.anchor(top: movieTitle.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 10, left: 10, bottom: 0, right: 10), size: .zero)
        movieDescription.anchor(top: movieSubtitle.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 10, left: 10, bottom: 0, right: 10), size: .zero)
    }

    func bind(to viewModel: MovieViewModel) {
        cancelImageLoading()
        cancellable = viewModel.poster.sink { [unowned self] image in self.showImage(image: image)}
        movieTitle.text = viewModel.title
        movieSubtitle.text = viewModel.subtitle
        movieDescription.text = viewModel.overview
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

}
