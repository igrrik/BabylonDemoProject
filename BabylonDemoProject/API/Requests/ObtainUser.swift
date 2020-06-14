//
//  ObtainUser.swift
//  BabylonDemoProject
//
//  Created by Igor Kokoev on 14.06.2020.
//  Copyright © 2020 Igor Kokoev. All rights reserved.
//

import Foundation

struct ObtainUser: APIRequest {
    typealias Response = User
    let endpoint: APIEndpoint

    init(userId: Int) {
        endpoint = .user(identifier: userId)
    }
}
