//
//  ImageProviderPublisher.swift
//  BabylonDemoProject
//
//  Created by Igor Kokoev on 24.06.2020.
//  Copyright © 2020 Igor Kokoev. All rights reserved.
//

import UIKit
import Combine
import Kingfisher

struct ImageProviderPublisher: Publisher {
    typealias Output = UIImage
    typealias Failure = Error

    let configuration: Configuration

    func receive<S>(subscriber: S) where S: Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
        let subscription = ImageProviderSubscription(subscriber: subscriber, configuration: configuration)
        subscriber.receive(subscription: subscription)
    }
}

extension ImageProviderPublisher {
    enum Configuration {
        case failure(Error)
        case url(URL, KingfisherManager)
    }
}

private final class ImageProviderSubscription<S: Subscriber>: Subscription
where S.Input == UIImage, S.Failure == Error {
    private let configuration: ImageProviderPublisher.Configuration
    private var subscriber: S?
    private var downloadTask: DownloadTask?

    init(subscriber: S, configuration: ImageProviderPublisher.Configuration) {
        self.subscriber = subscriber
        self.configuration = configuration
    }

    func request(_ demand: Subscribers.Demand) {
        switch configuration {
        case let .failure(error):
            _ = subscriber?.receive(completion: .failure(error))
        case let .url(url, kingfisher):
            downloadTask = kingfisher.retrieveImage(with: url) { [weak self] result in
                switch result {
                case .success(let imageResult):
                    _ = self?.subscriber?.receive(imageResult.image)
                case .failure(let error):
                    _ = self?.subscriber?.receive(completion: .failure(error))
                }
            }
        }
    }

    func cancel() {
        downloadTask?.cancel()
        subscriber = nil
    }
}
