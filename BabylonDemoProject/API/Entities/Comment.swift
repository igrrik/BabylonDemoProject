//
//  Comment.swift
//  BabylonDemoProject
//
//  Created by Igor Kokoev on 14.06.2020.
//  Copyright © 2020 Igor Kokoev. All rights reserved.
//

import Foundation

struct Comment: Decodable {
    let id: Int
    let postId: Int
    let name: String
    let email: String
    let body: String
}
