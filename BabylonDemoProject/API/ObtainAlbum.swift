//
//  ObtainAlbum.swift
//  BabylonDemoProject
//
//  Created by Igor Kokoev on 14.06.2020.
//  Copyright © 2020 Igor Kokoev. All rights reserved.
//

import Foundation

struct ObtainAlbum: APIRequest {
    let endpoint: APIEndpoint

    init(albumId: Int) {
        self.endpoint = .album(identifier: albumId)
    }
}

extension ObtainAlbum {
    struct Response: Decodable {
        let userId: Int
        let identifier: Int
        let title: String

        enum CodingKeys: String, CodingKey {
            case userId
            case identifier = "id"
            case title
        }
    }
}
