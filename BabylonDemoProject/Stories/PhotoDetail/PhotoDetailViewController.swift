//
//  PhotoDetailViewController.swift
//  BabylonDemoProject
//
//  Created by Igor Kokoev on 17.06.2020.
//  Copyright © 2020 Igor Kokoev. All rights reserved.
//

import UIKit

final class PhotoDetailViewController: UIViewController {
    private let viewModel: PhotoDetailViewModel
    private let photoImageView = UIImageView()
    private let titleLabel = UILabel()
    private let authorLabel = UILabel()
    private let commentsLabel = UILabel()

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
    }
}

private extension PhotoDetailViewController {
    func configureUI() {
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(photoImageView)
        NSLayoutConstraint.activate([
            photoImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            photoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            photoImageView.heightAnchor.constraint(equalTo: photoImageView.widthAnchor)
        ])
    }
}
