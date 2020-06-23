//
//  ObtainCommentsOfPhoto.swift
//  BabylonDemoProject
//
//  Created by Igor Kokoev on 14.06.2020.
//  Copyright © 2020 Igor Kokoev. All rights reserved.
//

import Foundation

struct ObtainCommentsOfPhoto: APIRequest {
    typealias Response = [Comment]
    let endpoint: APIEndpoint

    init(photoId: Int) {
        endpoint = .commentsOfPhoto(identifier: photoId)
    }
}
