//
//  Album.swift
//  BabylonDemoProject
//
//  Created by Igor Kokoev on 14.06.2020.
//  Copyright © 2020 Igor Kokoev. All rights reserved.
//

import Foundation

struct Album: Decodable {
    let id: Int
    let userId: Int
    let title: String
}
