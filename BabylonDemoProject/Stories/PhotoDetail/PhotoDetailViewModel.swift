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
    private let photo: Photo
    private let apiService: APIService
    private let imageProvider: ImageProvider
    private let photoImageSubject = CurrentValueSubject<UIImage?, Never>(nil)
    private let authorNameSubject = CurrentValueSubject<String?, Never>(nil)
    private let commentsCountSubject = CurrentValueSubject<Int?, Never>(nil)
    private let isLoadingSubject = CurrentValueSubject<Bool, Never>(false)
    private let errorSubject = PassthroughSubject<Error, Never>()
    private var subscribtions = Set<AnyCancellable>()

    init(photo: Photo, apiService: APIService, imageProvider: ImageProvider) {
        self.photo = photo
        self.apiService = apiService
        self.imageProvider = imageProvider
    }

    func obtainData() {
        isLoadingSubject.send(true)

        obtainPhoto()
        
        Publishers.Zip(obtainAuthorName(), obtainComments())
            .sink(receiveValue: { [weak self] authorName, commentsCount in
                self?.commentsCountSubject.send(commentsCount)
                self?.authorNameSubject.send(authorName)
                self?.isLoadingSubject.send(false)
            })
            .store(in: &subscribtions)
    }
}

extension PhotoDetailViewModel {
    var photoImage: AnyPublisher<UIImage, Never> { photoImageSubject.compactMap { $0 }.eraseToAnyPublisher() }
    var photoTitle: String { photo.title }
    var isLoading: AnyPublisher<Bool, Never> { isLoadingSubject.eraseToAnyPublisher() }
    var error: AnyPublisher<Error, Never> { errorSubject.eraseToAnyPublisher() }
    var authorName: AnyPublisher<String, Never> {
        authorNameSubject.compactMap { value in
            guard let value = value else {
                return nil
            }
            return "Author: \(value)"
        }
        .eraseToAnyPublisher()
    }
    var commentsCount: AnyPublisher<String, Never> {
        commentsCountSubject.compactMap(commentsString(with:)).eraseToAnyPublisher()
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

    func obtainAuthorName() -> AnyPublisher<String, Never> {
        return apiService
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
            .handleEvents(receiveCompletion: { [weak self] completion in
                self?.process(completion)
            })
            .replaceError(with: "–")
            .eraseToAnyPublisher()
    }

    func obtainComments() -> AnyPublisher<Int, Never>{
        return apiService
            .send(request: ObtainCommentsOfPhoto(photoId: photo.id))
            .createPublisher()
            .handleEvents(receiveCompletion: { [weak self] completion in
                self?.process(completion)
            })
            .map(\.count)
            .replaceError(with: 0)
            .eraseToAnyPublisher()
    }

    func process(_ completion: Subscribers.Completion<Error>) {
        guard case let .failure(error) = completion else {
            return
        }
        errorSubject.send(error)
    }

    func commentsString(with count: Int?) -> String? {
        guard let count = count else {
            return nil
        }
        let comment = count == 1 ? "comment" : "comments"
        return "\(count) \(comment)"
    }
}
