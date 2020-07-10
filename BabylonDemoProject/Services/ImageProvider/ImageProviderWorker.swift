//
//  ImageProviderWorker.swift
//  BabylonDemoProject
//
//  Created by Igor Kokoev on 17.06.2020.
//  Copyright © 2020 Igor Kokoev. All rights reserved.
//

import UIKit
import Combine
import Kingfisher

final class ImageProviderWorker: ImageProvider {
    static let shared = ImageProviderWorker()
    private let kingfisher: KingfisherManager

    init(kingfisher: KingfisherManager = .shared) {
        self.kingfisher = kingfisher
    }

    func obtainImage(with url: URL) -> Deferred<ImagePublisher> {
        return Deferred { [weak self] in
            guard let self = self else {
                return ImagePublisher(configuration: .failure(ObjectDeallocatedError()))
            }
            return ImagePublisher(configuration: .url(url, self.kingfisher))
        }
    }

    func prefetchImages(with urls: [URL]) {
        ImagePrefetcher(urls: urls, options: [.downloader(kingfisher.downloader)]).start()
    }
}
