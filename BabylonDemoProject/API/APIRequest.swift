//
//  APIRequest.swift
//  BabylonDemoProject
//
//  Created by Igor Kokoev on 14.06.2020.
//  Copyright © 2020 Igor Kokoev. All rights reserved.
//

import Foundation

protocol APIRequest {
    associatedtype Response: Decodable

    var endpoint: APIEndpoint { get }
}
