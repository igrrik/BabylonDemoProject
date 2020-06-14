//
//  PhotosListViewController.swift
//  BabylonDemoProject
//
//  Created by Igor Kokoev on 14.06.2020.
//  Copyright © 2020 Igor Kokoev. All rights reserved.
//

import UIKit
import Combine

final class PhotosListViewController: UIViewController {
    @IBOutlet private weak var collectionView: UICollectionView?
    @IBOutlet private weak var loadingIndicator: UIActivityIndicatorView?

    private var photos = [Photo]()
    private var dataSource = [PhotoCollectionViewCell.Model]()
    private let cellReuseId = "PhotoCell"
    private let sectionInsets = UIEdgeInsets(top: 20.0, left: 10.0, bottom: 20.0, right: 10.0)
    private let itemsPerRow: CGFloat = 3
    private let service: APIService = LocalAPIService()
    private var subscriptions = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadPhotos()
    }
}

private extension PhotosListViewController {
    func configureUI() {
        collectionView?.dataSource = self
        collectionView?.delegate = self

        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.sectionInset = sectionInsets
        }
    }

    func loadPhotos() {
        loadingIndicator?.startAnimating()
        service.send(request: ObtainPhotos())
            .createPublisher()
            .handleEvents(receiveOutput: { [weak self] photos in
                self?.photos = photos
            })
            .map { $0.map(\.thumbnailUrl) }
            .map { $0.map(PhotoCollectionViewCell.Model.init(imageURL:)) }
            .sink(receiveCompletion: { [weak self] completion in
                self?.loadingIndicator?.stopAnimating()
                guard case let .failure(error) = completion else {
                    return
                }
                self?.show(error)
            }, receiveValue: { [weak self] models in
                self?.loadingIndicator?.stopAnimating()
                self?.dataSource = models
                self?.collectionView?.reloadData()
            })
            .store(in: &subscriptions)
    }

    func show(_ error: Error) {
        let alert = UIAlertController(
            title: "Error",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}

extension PhotosListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photos.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseId, for: indexPath)
        if let photoCell = cell as? PhotoCollectionViewCell {
            let model = dataSource[indexPath.item]
            photoCell.configure(with: model)
        }
        return cell
    }
}

extension PhotosListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = collectionView.frame.width - paddingSpace
        let widthPerItem = (availableWidth / itemsPerRow).rounded(.down)

        return CGSize(width: widthPerItem, height: widthPerItem)
    }
}
