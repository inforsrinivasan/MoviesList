//
//  MoviesDetailViewController.swift
//  MoviesList
//
//  Created by Srinivasan Rajendran on 2020-04-12.
//  Copyright © 2020 Srinivasan Rajendran. All rights reserved.
//

import UIKit
import Combine

class MoviesDetailViewController: UIViewController {

    let viewModel: MovieDetailVMTransforming
    private var cancellables: [AnyCancellable] = []
    private let appear = PassthroughSubject<Void, Never>()
    lazy var  movieDetailView = MovieDetailsView(frame: view.bounds)

    init(viewModel: MovieDetailVMTransforming) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setBindings()
        appear.send()
    }

    private func setUpView() {
        view.addSubview(movieDetailView)
        movieDetailView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .zero, size: .zero)
    }

    private func setBindings() {
        let input = MovieDetailVMInput(appear: appear.eraseToAnyPublisher())
        let output = viewModel.transform(input: input)
        output.sink { state in
            switch state {
            case .loading:
                print("loading")
            case .success(let movieViewModel):
                self.showMovieDetails(movieViewModel: movieViewModel)
            case .failure(let error):
                print(error)
            }
        }.store(in: &cancellables)
    }

    private func showMovieDetails(movieViewModel: MovieViewModel) {
        movieDetailView.bind(to: movieViewModel)
    }

}
