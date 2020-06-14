//
//  LocalAPIService.swift
//  BabylonDemoProject
//
//  Created by Igor Kokoev on 15.06.2020.
//  Copyright © 2020 Igor Kokoev. All rights reserved.
//

import UIKit
import Combine

final class LocalAPIService: APIService {
    private let decoder = JSONDecoder()

    func send<T: APIRequest>(request: T) -> APIResponse<T> {
        return APIResponse<T> { [weak self] in
            return Future<T.Response, Error> { promise in
                guard let self = self else {
                    promise(.failure(ObjectDeallocatedError()))
                    return
                }
                let requestName = String(describing: type(of: request))
                guard let asset = NSDataAsset(name: requestName) else {
                    promise(.failure(Failure.failedToLocateJSONFile))
                    return
                }
                do {
                    let result = try self.decoder.decode(T.Response.self, from: asset.data)
                    return promise(.success(result))
                } catch {
                    return promise(.failure(error))
                }
            }
        }
    }
}

extension LocalAPIService {
    enum Failure: Error {
        case failedToLocateJSONFile
    }
}
