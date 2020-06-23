//
//  ObtainPhotos.swift
//  BabylonDemoProject
//
//  Created by Igor Kokoev on 14.06.2020.
//  Copyright © 2020 Igor Kokoev. All rights reserved.
//

import Foundation

struct ObtainPhotos: APIRequest {
    typealias Response = [Photo]
    let endpoint: APIEndpoint = .photos
}
