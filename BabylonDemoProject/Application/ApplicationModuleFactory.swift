//
//  ApplicationModuleFactory.swift
//  BabylonDemoProject
//
//  Created by Igor Kokoev on 16.06.2020.
//  Copyright © 2020 Igor Kokoev. All rights reserved.
//

import UIKit

final class ApplicationModuleFactory {
    private let apiService: APIService

    init(localhost: Bool = false) {
        apiService = localhost ? LocalAPIService() : APIWorker()
    }

    func makePhotosListModule() -> UIViewController {
        let viewModel = PhotosListViewModel(apiService: apiService)
        let viewController = PhotosListViewController(viewModel: viewModel)
        return UINavigationController(rootViewController: viewController)
    }

    func makePhotoDetailModule(photo: Photo) -> UIViewController {
        return UIViewController()
    }
}
