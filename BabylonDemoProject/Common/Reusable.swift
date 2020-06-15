//
//  Reusable.swift
//  BabylonDemoProject
//
//  Created by Igor Kokoev on 16.06.2020.
//  Copyright © 2020 Igor Kokoev. All rights reserved.
//

import Foundation

protocol Reusable: AnyObject {
    static var reuseId: String { get }
}

extension Reusable {
    static var reuseId: String { String(describing: self) }
}
