//
//  PhotosListViewController.swift
//  BabylonDemoProject
//
//  Created by Igor Kokoev on 14.06.2020.
//  Copyright © 2020 Igor Kokoev. All rights reserved.
//

import UIKit
import Combine

final class PhotosListViewController: UIViewController, ErrorPresentable {
    private let viewModel: PhotosListViewModel
    private let collectionViewInsets = UIEdgeInsets(top: 20.0, left: 10.0, bottom: 20.0, right: 10.0)
    private let flowLayout = UICollectionViewFlowLayout()
    private let collectionView: UICollectionView
    private let loadingIndicator = LoadingIndicatorView()
    private let appModulesFactory: ApplicationModulesFactory
    private var subscriptions = Set<AnyCancellable>()
    private var dataSource = [PhotoCollectionViewCell.Model]() {
        didSet {
            collectionView.reloadData()
        }
    }

    init(viewModel: PhotosListViewModel, appModulesFactory: ApplicationModulesFactory) {
        self.viewModel = viewModel
        self.appModulesFactory = appModulesFactory
        self.collectionView = .init(frame: .zero, collectionViewLayout: flowLayout)
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bind(to: viewModel)
        viewModel.loadPhotos()
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
        let cell: PhotoCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        let model = dataSource[indexPath.item]
        cell.configure(with: model)
        return cell
    }
}

extension PhotosListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let itemsPerRow: CGFloat = 3
        let paddingSpace = collectionViewInsets.left * (itemsPerRow + 1)
        let availableWidth = collectionView.frame.width - paddingSpace
        let widthPerItem = (availableWidth / itemsPerRow).rounded(.down)

        return CGSize(width: widthPerItem, height: widthPerItem)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photo = dataSource[indexPath.item].photo
        showDetail(with: photo)
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

private extension PhotosListViewController {
    func configureUI() {
        title = "Photos"
        view.backgroundColor = .white
        configureCollectionView()
        configureLoadingIndicator()
    }

    func configureCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        flowLayout.sectionInset = collectionViewInsets
        collectionView.registerCellOfType(PhotoCollectionViewCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    func configureLoadingIndicator() {
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loadingIndicator)
        NSLayoutConstraint.activate([
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    func bind(to viewModel: PhotosListViewModel) {
        viewModel.error
            .sink(receiveValue: { [weak self] error in
                self?.show(error)
            })
            .store(in: &subscriptions)

        viewModel.isLoading
            .assign(to: \.isVisible, on: loadingIndicator)
            .store(in: &subscriptions)

        viewModel.photos
            .map { $0.map(PhotoCollectionViewCell.Model.init(photo:)) }
            .assign(to: \.dataSource, on: self)
            .store(in: &subscriptions)
    }

    func showDetail(with photo: Photo) {
        let viewController = appModulesFactory.makePhotoDetailModule(photo: photo)
        showDetailViewController(viewController, sender: self)
    }
}
