//
//  NetworkManager.swift
//  MoviesList
//
//  Created by Srinivasan Rajendran on 2020-04-13.
//  Copyright © 2020 Srinivasan Rajendran. All rights reserved.
//

import Foundation
import Combine

final class NetworkManager: Networking {

    private let session: URLSession

    init(session: URLSession = URLSession(configuration: URLSessionConfiguration.ephemeral)) {
        self.session = session
    }

    func load<T>(resource: Resource<T>) -> AnyPublisher<Result<T, NetworkError>, Never> where T : Decodable {

        guard let request = resource.request else {
            return Just<Result<T, NetworkError>>(.failure(NetworkError.invalidRequest))
            .eraseToAnyPublisher()
        }

        return session.dataTaskPublisher(for: request)
            .mapError { _ in NetworkError.invalidResponse }
            .flatMap { data, response -> AnyPublisher<Data, Error> in
                guard let response = response as? HTTPURLResponse else {
                    return .fail(NetworkError.invalidResponse)
                }
                guard case 200...299 = response.statusCode else {
                    return .fail(NetworkError.invalidResponse)
                }
                return .just(data)
            }
        .decode(type: T.self, decoder: JSONDecoder())
        .map { .success($0) }
        .catch { error in Just(.failure(NetworkError.jsonDecodingError(error: error)))}
        .eraseToAnyPublisher()
    }

}

extension Publisher {

    static func empty() -> AnyPublisher<Output, Failure> {
        return Empty().eraseToAnyPublisher()
    }

    static func just(_ output: Output) -> AnyPublisher<Output, Failure> {
        return Just(output)
            .catch { _ in AnyPublisher<Output, Failure>.empty() }
            .eraseToAnyPublisher()
    }

    static func fail(_ error: Failure) -> AnyPublisher<Output, Failure> {
        return Fail(error: error).eraseToAnyPublisher()
    }
}

extension Publisher {

//    The flatMapLatest operator behaves much like the standard FlatMap operator, except that whenever
//    a new item is emitted by the source Publisher, it will unsubscribe to and stop mirroring the Publisher
//    that was generated from the previously-emitted item, and begin only mirroring the current one.
    func flatMapLatest<T: Publisher>(_ transform: @escaping (Self.Output) -> T) -> Publishers.SwitchToLatest<T, Publishers.Map<Self, T>> where T.Failure == Self.Failure {
        map(transform).switchToLatest()
    }
}
