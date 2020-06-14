//
//  APIWorker.swift
//  BabylonDemoProject
//
//  Created by Igor Kokoev on 14.06.2020.
//  Copyright © 2020 Igor Kokoev. All rights reserved.
//

import Foundation
import Combine

final class APIWorker: APIService {
    private let session: URLSession
    private let decoder: JSONDecoder
    private let delegateQueue: DispatchQueue
    private var subscriptions = Set<AnyCancellable>()

    init(session: URLSession, decoder: JSONDecoder, delegateQueue: DispatchQueue) {
        self.session = session
        self.decoder = decoder
        self.delegateQueue = delegateQueue
    }

    convenience init() {
        self.init(session: URLSession.shared, decoder: JSONDecoder(), delegateQueue: DispatchQueue.main)
    }

    func send<T: APIRequest>(request: T) -> APIResponse<T> {
        return APIResponse<T> { [weak self] in
            return Future<T.Response, Error> { promise in
                guard let self = self else {
                    promise(.failure(ObjectDeallocatedError()))
                    return
                }
                Just(request.endpoint)
                    .tryMap { try $0.url() }
                    .flatMap { [weak self] url -> AnyPublisher<URLSession.DataTaskPublisher.Output, Error> in
                        guard let self = self else {
                            let fail = Fail<URLSession.DataTaskPublisher.Output, Error>(error: ObjectDeallocatedError())
                            return fail.eraseToAnyPublisher()
                        }
                        return self.session
                            .dataTaskPublisher(for: url)
                            .mapError { $0 as Error }
                            .eraseToAnyPublisher()
                    }
                    .map(\.data)
                    .decode(type: T.Response.self, decoder: self.decoder)
                    .receive(on: self.delegateQueue)
                    .eraseToAnyPublisher()
                    .sink(receiveCompletion: { completion in
                        guard case let .failure(error) = completion else {
                            return
                        }
                        promise(.failure(error))
                    }, receiveValue: { response in
                        promise(.success(response))
                    })
                    .store(in: &self.subscriptions)
            }
        }
    }
}
