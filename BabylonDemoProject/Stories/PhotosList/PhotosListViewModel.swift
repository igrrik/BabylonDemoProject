//
//  PhotosListViewModel.swift
//  BabylonDemoProject
//
//  Created by Igor Kokoev on 16.06.2020.
//  Copyright © 2020 Igor Kokoev. All rights reserved.
//

import Foundation
import Combine

final class PhotosListViewModel {
    var photos: AnyPublisher<[Photo], Never> { photosSubject.eraseToAnyPublisher() }
    var isLoading: AnyPublisher<Bool, Never> { isLoadingSubject.eraseToAnyPublisher() }
    var error: AnyPublisher<Error, Never> { errorSubject.eraseToAnyPublisher() }

    private let photosSubject = CurrentValueSubject<[Photo], Never>([])
    private let isLoadingSubject = CurrentValueSubject<Bool, Never>(false)
    private let errorSubject = PassthroughSubject<Error, Never>()
    private let apiService: APIService
    private var subscriptions = Set<AnyCancellable>()

    init(apiService: APIService) {
        self.apiService = apiService
    }

    func loadPhotos() {
        isLoadingSubject.send(true)
        apiService.send(request: ObtainPhotos())
            .createPublisher()
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoadingSubject.send(false)
                guard case let .failure(error) = completion else {
                    return
                }
                self?.errorSubject.send(error)
            }, receiveValue: { [weak self] photos in
                self?.photosSubject.send(photos)
            })
            .store(in: &subscriptions)
    }
}
