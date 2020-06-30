//
//  ApplicationModulesFactory.swift
//  BabylonDemoProject
//
//  Created by Igor Kokoev on 16.06.2020.
//  Copyright © 2020 Igor Kokoev. All rights reserved.
//

import UIKit

final class ApplicationModulesFactory {
    private let apiService: APIService
    private let imageProvider: ImageProvider

    init(localhost: Bool = false) {
        apiService = localhost ? LocalAPIService() : APIWorker()
        imageProvider = ImageProviderWorker.shared
    }

    func makePhotosListModule() -> UIViewController {
        let viewModel = PhotosListViewModel(apiService: apiService)
        let viewController = PhotosListViewController(viewModel: viewModel, appModulesFactory: self)
        return UINavigationController(rootViewController: viewController)
    }

    func makePhotoDetailModule(photo: Photo) -> UIViewController {
        let viewModel = PhotoDetailViewModel(photo: photo, apiService: apiService, imageProvider: imageProvider)
        let viewController = PhotoDetailViewController(viewModel: viewModel)
        return viewController
    }
}
