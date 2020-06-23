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
    var photoImage: AnyPublisher<UIImage, Never> { photoImageSubject.eraseToAnyPublisher() }
    var photoTitle: String { photo.title }
    var authorName: AnyPublisher<String, Never> { authorNameSubject.map { "Author: \($0)" }.eraseToAnyPublisher() }
    var isLoading: AnyPublisher<Bool, Never> { isLoadingSubject.eraseToAnyPublisher() }
    var commentsCount: AnyPublisher<String, Never> {
        commentsCountSubject.map(commentsString(with:)).eraseToAnyPublisher()
    }

    private let photo: Photo
    private let apiService: APIService
    private let photoImageSubject = PassthroughSubject<UIImage, Never>()
    private let authorNameSubject = CurrentValueSubject<String, Never>("")
    private let commentsCountSubject = CurrentValueSubject<Int, Never>(0)
    private let isLoadingSubject = CurrentValueSubject<Bool, Never>(false)

    init(apiService: APIService, photo: Photo) {
        self.apiService = apiService
        self.photo = photo
    }

    private func commentsString(with count: Int) -> String {
        let comment = count == 1 ? "comment" : "comments"
        return "\(count) \(comment)"
    }
}
