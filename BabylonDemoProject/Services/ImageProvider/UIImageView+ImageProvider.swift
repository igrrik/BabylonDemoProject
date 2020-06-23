//
//  UIImageView+ImageProvider.swift
//  BabylonDemoProject
//
//  Created by Igor Kokoev on 17.06.2020.
//  Copyright © 2020 Igor Kokoev. All rights reserved.
//

import UIKit
import Combine

extension UIImageView {
    func setImage(with url: URL) -> Cancellable {
        return ImageProviderWorker.shared
            .obtainImage(with: url)
            .replaceError(with: #imageLiteral(resourceName: "placeholder"))
            .sink(receiveValue: { [weak self] image in
                DispatchQueue.main.async {
                    self?.image = image
                }
            })
    }
}
