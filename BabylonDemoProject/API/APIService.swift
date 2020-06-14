//
//  APIService.swift
//  BabylonDemoProject
//
//  Created by Igor Kokoev on 13.06.2020.
//  Copyright © 2020 Igor Kokoev. All rights reserved.
//

import Foundation
import Combine

protocol APIService {

    func send<T: APIRequest>(request: T) -> APIResponse<T>
}

typealias APIResponse<T: APIRequest> = Deferred<Future<T.Response, Error>>
