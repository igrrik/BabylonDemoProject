//
//  APIClient.swift
//  BabylonDemoProject
//
//  Created by Igor Kokoev on 13.06.2020.
//  Copyright © 2020 Igor Kokoev. All rights reserved.
//

import Foundation
import Combine

struct ObjectDeallocatedError: Error {}

protocol APIRequest {
    associatedtype Response: Decodable

    var endpoint: APIEndpoint { get }
}

enum APIEndpoint {

    case photos
    case commentsOfPhoto(identifier: Int)
    case album(identifier: Int)
    case user(identifier: Int)

    static let baseURl: String = "http://jsonplaceholder.typicode.com"

    func url() throws -> URL {
        var path: String

        switch self {
        case .photos:
            path = "photos"
        case .commentsOfPhoto(let identifier):
            path = "photos/\(identifier)/comments"
        case .album(let identifier):
            path = "albums/\(identifier)"
        case .user(let identifier):
            path = "users/\(identifier)"
        }

        path = Self.baseURl + "/" + path

        guard let url = URL(string: path) else {
            throw Failure.failedToInitialiseURLWithPath(path)
        }
        return url
    }
}

extension APIEndpoint {
    enum Failure: Error {
        case failedToInitialiseURLWithPath(String)
    }
}

final class APIClient {

    private let session: URLSession
    private let decoder: JSONDecoder
    private let delegateQueue: DispatchQueue
    private var cancellableBag = Set<AnyCancellable>()

    init(session: URLSession, decoder: JSONDecoder, delegateQueue: DispatchQueue) {
        self.session = session
        self.decoder = decoder
        self.delegateQueue = delegateQueue
    }

    convenience init() {
        self.init(session: URLSession.shared, decoder: JSONDecoder(), delegateQueue: DispatchQueue.main)
    }

    func send<T: APIRequest>(request: T) -> Future<T.Response, Error> {
        let data = Deferred {
            return Future<URL, Error> { promise in
                do {
                    let url = try request.endpoint.url()
                    return promise(.success(url))
                } catch {
                    return promise(.failure(error))
                }
            }
        }
        .flatMap { [session] url in
            session
                .dataTaskPublisher(for: url)
                .mapError { $0 as Error }
        }
        .map { $0.data }
        .decode(type: T.Response.self, decoder: self.decoder)
        .receive(on: delegateQueue)
        .eraseToAnyPublisher()

        let value = Deferred<Future<T.Response, Error>> { [weak self] in
            guard let self = self else {
                return Future<T.Response, Error> { $0(.failure(ObjectDeallocatedError())) }
            }
            return Future<T.Response, Error> { promise in
                data.sink(receiveCompletion: { completion in
                    guard case let .failure(error) = completion else {
                        return
                    }
                    promise(.failure(error))
                }, receiveValue: { response in
                    promise(.success(response))
                })
                .store(in: &self.cancellableBag)
            }
        }

        return value.createPublisher()
    }
}
