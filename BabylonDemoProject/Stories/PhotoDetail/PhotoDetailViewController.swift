//
//  PhotoDetailViewController.swift
//  BabylonDemoProject
//
//  Created by Igor Kokoev on 17.06.2020.
//  Copyright © 2020 Igor Kokoev. All rights reserved.
//

import UIKit
import Combine

final class PhotoDetailViewController: UIViewController, ErrorPresentable {
    private let viewModel: PhotoDetailViewModel
    private let loadingIndicator = LoadingIndicatorView()
    private let labelsStackView = UIStackView()
    private let photoImageView = UIImageView()
    private let titleLabel = UILabel()
    private let authorLabel = UILabel()
    private let commentsLabel = UILabel()
    private let spacing: CGFloat = 16
    private var subscribptions = Set<AnyCancellable>()

    init(viewModel: PhotoDetailViewModel) {
        self.viewModel = viewModel
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

        viewModel.obtainData()
    }
}

private extension PhotoDetailViewController {

    func bind(to viewModel: PhotoDetailViewModel) {
        titleLabel.text = viewModel.photoTitle

        viewModel.isLoading
            .assign(to: \.isHidden, on: labelsStackView)
            .store(in: &subscribptions)

        viewModel.isLoading
            .assign(to: \.isVisible, on: loadingIndicator)
            .store(in: &subscribptions)

        viewModel.photoImage
            .map(Optional.init)
            .assign(to: \.image, on: photoImageView)
            .store(in: &subscribptions)

        viewModel.authorName
            .map(Optional.init)
            .assign(to: \.text, on: authorLabel)
            .store(in: &subscribptions)

        viewModel.commentsCount
            .map(Optional.init)
            .assign(to: \.text, on: commentsLabel)
            .store(in: &subscribptions)

        viewModel.error
            .sink(receiveValue: { [weak self] error in
                self?.show(error)
            })
            .store(in: &subscribptions)
    }

    func configureUI() {
        view.backgroundColor = .white
        configurePhotoImageView()
        configureLabels()
        configureLoadingIndicator()
    }

    func configurePhotoImageView() {
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(photoImageView)
        NSLayoutConstraint.activate([
            photoImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            photoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            photoImageView.heightAnchor.constraint(equalTo: photoImageView.widthAnchor)
        ])
    }

    func configureLabels() {
        titleLabel.numberOfLines = 0
        titleLabel.textColor = .darkText
        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)

        authorLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        authorLabel.textColor = .secondaryLabel

        commentsLabel.font = UIFont.preferredFont(forTextStyle: .caption2)
        commentsLabel.textColor = .secondaryLabel

        [titleLabel, authorLabel, commentsLabel].forEach { labelsStackView.addArrangedSubview($0) }
        labelsStackView.axis = .vertical
        labelsStackView.spacing = (spacing / 2).rounded()
        labelsStackView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(labelsStackView)
        NSLayoutConstraint.activate([
            labelsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: spacing),
            labelsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -spacing),
            labelsStackView.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: spacing)
        ])
    }

    func configureLoadingIndicator() {
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loadingIndicator)
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: spacing)
        ])
    }
}
