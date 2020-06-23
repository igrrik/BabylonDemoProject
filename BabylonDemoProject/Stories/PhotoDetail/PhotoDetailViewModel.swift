//
//  PhotoDetailViewModel.swift
//  BabylonDemoProject
//
//  Created by Igor Kokoev on 17.06.2020.
//  Copyright © 2020 Igor Kokoev. All rights reserved.
//

import UIKit
import Combine

final class PhotoDetailViewModel {
    var photoImage: AnyPublisher<UIImage, Never> { photoImageSubject.compactMap { $0 }.eraseToAnyPublisher() }
    var photoTitle: String { photo.title }
    var authorName: AnyPublisher<String, Never> { authorNameSubject.map { "Author: \($0)" }.eraseToAnyPublisher() }
    var isLoading: AnyPublisher<Bool, Never> { isLoadingSubject.eraseToAnyPublisher() }
    var commentsCount: AnyPublisher<String, Never> {
        commentsCountSubject.map(commentsString(with:)).eraseToAnyPublisher()
    }

    private let photo: Photo
    private let apiService: APIService
    private let imageProvider: ImageProvider
    private let photoImageSubject = CurrentValueSubject<UIImage?, Never>(nil)
    private let authorNameSubject = CurrentValueSubject<String, Never>("")
    private let commentsCountSubject = CurrentValueSubject<Int, Never>(0)
    private let isLoadingSubject = CurrentValueSubject<Bool, Never>(false)
    private var subscribtions = Set<AnyCancellable>()

    init(photo: Photo, apiService: APIService, imageProvider: ImageProvider) {
        self.photo = photo
        self.apiService = apiService
        self.imageProvider = imageProvider
    }

    func loadData() {
        loadPhoto()
    }
}

private extension PhotoDetailViewModel {
    func loadPhoto() {
        let thumbnail = imageProvider
            .obtainImage(with: photo.thumbnailUrl)
            .createPublisher()
            .replaceError(with: #imageLiteral(resourceName: "placeholder"))
            .map(Optional.init)

        let fullPhoto = imageProvider
            .obtainImage(with: photo.url)
            .createPublisher()
            .map(Optional.init)
            .replaceError(with: nil)

        thumbnail
            .merge(with: fullPhoto)
            .sink { [weak self] value in
                switch value {
                case .some(let image):
                    self?.photoImageSubject.send(image)
                case .none:
                    break
                }
            }
            .store(in: &subscribtions)
    }

    func commentsString(with count: Int) -> String {
        let comment = count == 1 ? "comment" : "comments"
        return "\(count) \(comment)"
    }
}
