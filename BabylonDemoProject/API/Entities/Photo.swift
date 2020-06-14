//
//  Photo.swift
//  BabylonDemoProject
//
//  Created by Igor Kokoev on 14.06.2020.
//  Copyright © 2020 Igor Kokoev. All rights reserved.
//

import Foundation

struct Photo {
    let id: Int
    let albumId: Int
    let title: String
    let url: URL
    let thumbnailUrl: URL
}

extension Photo: Decodable {
    private enum CodingKeys: String, CodingKey {
        case albumId
        case id
        case title
        case url
        case thumbnailUrl
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        albumId = try container.decode(Int.self, forKey: .albumId)
        id = try container.decode(Int.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        url = try container.decode(URL.self, forKey: .url)
        thumbnailUrl = try container.decode(URL.self, forKey: .thumbnailUrl)
    }
}
