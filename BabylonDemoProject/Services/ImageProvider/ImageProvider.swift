//
//  ImageProvider.swift
//  BabylonDemoProject
//
//  Created by Igor Kokoev on 17.06.2020.
//  Copyright © 2020 Igor Kokoev. All rights reserved.
//

import UIKit
import Combine

protocol ImageProvider {

    func obtainImage(with url: URL) -> Deferred<ImageProviderPublisher>
}
