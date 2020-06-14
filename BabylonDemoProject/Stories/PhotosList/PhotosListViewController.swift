//
//  PhotosListViewController.swift
//  BabylonDemoProject
//
//  Created by Igor Kokoev on 14.06.2020.
//  Copyright © 2020 Igor Kokoev. All rights reserved.
//

import UIKit

final class PhotosListViewController: UIViewController {
    @IBOutlet private weak var collectionView: UICollectionView?
    @IBOutlet private weak var loadingIndicator: UIActivityIndicatorView?

    private var photos = [Photo]()
    private var dataSource = [PhotoCollectionViewCell.Model]()
    private let cellReuseId = "PhotoCell"
    private let sectionInsets = UIEdgeInsets(top: 20.0, left: 10.0, bottom: 20.0, right: 10.0)
    private let itemsPerRow: CGFloat = 3

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.dataSource = self
        collectionView?.delegate = self
        for index in 0...30 {
            let color: UIColor = index % 2 == 0 ? .red : .black
            let model = PhotoCollectionViewCell.Model(backgroundColor: color)
            dataSource.append(model)
        }

        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.sectionInset = sectionInsets
        }

        collectionView?.reloadData()
    }
}

extension PhotosListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataSource.count
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
