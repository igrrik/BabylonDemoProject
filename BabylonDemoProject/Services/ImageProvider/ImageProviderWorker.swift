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

    func obtainImage(with url: URL) -> Deferred<ImageProviderPublisher> {
        return Deferred { [weak self] in
            guard let self = self else {
                return ImageProviderPublisher(configuration: .failure(ObjectDeallocatedError()))
            }
            return ImageProviderPublisher(configuration: .url(url, self.kingfisher))
        }
    }
}
