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
    var error: AnyPublisher<Error, Never> { errorSubject.eraseToAnyPublisher() }
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
    private let errorSubject = PassthroughSubject<Error, Never>()
    private var subscribtions = Set<AnyCancellable>()

    init(photo: Photo, apiService: APIService, imageProvider: ImageProvider) {
        self.photo = photo
        self.apiService = apiService
        self.imageProvider = imageProvider
    }

    func obtainData() {
        obtainPhoto()
        obtainAuthorName()
    }
}

private extension PhotoDetailViewModel {
    func obtainPhoto() {
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

    func obtainAuthorName() {
        apiService
            .send(request: ObtainAlbum(albumId: photo.albumId))
            .createPublisher()
            .map(\.userId)
            .flatMap { [weak self] userId -> AnyPublisher<User, Error> in
                guard let self = self else {
                    return Fail<User, Error>(error: ObjectDeallocatedError()).eraseToAnyPublisher()
                }
                return self.apiService
                    .send(request: ObtainUser(userId: userId))
                    .createPublisher()
                    .eraseToAnyPublisher()
            }
            .map(\.username)
            .sink(receiveCompletion: { [weak self] completion in
                guard case let .failure(error) = completion else {
                    return
                }
                self?.errorSubject.send(error)
            }, receiveValue: { [weak self] userName in
                self?.authorNameSubject.send(userName)
            })
            .store(in: &subscribtions)
    }

    func commentsString(with count: Int) -> String {
        let comment = count == 1 ? "comment" : "comments"
        return "\(count) \(comment)"
    }
}
