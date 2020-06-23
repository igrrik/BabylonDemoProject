//
//  ObtainAlbum.swift
//  BabylonDemoProject
//
//  Created by Igor Kokoev on 14.06.2020.
//  Copyright © 2020 Igor Kokoev. All rights reserved.
//

import Foundation

struct ObtainAlbum: APIRequest {
    typealias Response = Album
    let endpoint: APIEndpoint

    init(albumId: Int) {
        endpoint = .album(identifier: albumId)
    }
}
