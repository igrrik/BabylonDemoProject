//
//  APIEndpoint.swift
//  BabylonDemoProject
//
//  Created by Igor Kokoev on 14.06.2020.
//  Copyright © 2020 Igor Kokoev. All rights reserved.
//

import Foundation

enum APIEndpoint {

    case photos
    case commentsOfPhoto(identifier: Int)
    case album(identifier: Int)
    case user(identifier: Int)

    static let baseURl: String = "http://jsonplaceholder.typicode.com"

    func url() throws -> URL {
        var path: String

        switch self {
        case .photos:
            path = "photos"
        case .commentsOfPhoto(let identifier):
            path = "posts/\(identifier)/comments"
        case .album(let identifier):
            path = "albums/\(identifier)"
        case .user(let identifier):
            path = "users/\(identifier)"
        }

        path = Self.baseURl + "/" + path

        guard let url = URL(string: path) else {
            throw Failure.failedToInitialiseURLWithPath(path)
        }
        return url
    }
}

extension APIEndpoint {
    enum Failure: Error {
        case failedToInitialiseURLWithPath(String)
    }
}
