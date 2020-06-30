//
//  PhotoCollectionViewCell.swift
//  BabylonDemoProject
//
//  Created by Igor Kokoev on 14.06.2020.
//  Copyright © 2020 Igor Kokoev. All rights reserved.
//

import UIKit
import Combine

final class PhotoCollectionViewCell: UICollectionViewCell {
    private let photoImageView = UIImageView()
    private var downloadTask: Cancellable?

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        downloadTask?.cancel()
    }

    func configure(with model: Model) {
        downloadTask = photoImageView.setImage(with: model.photo.thumbnailUrl)
    }

    private func configureUI() {
        contentView.backgroundColor = .gray
        photoImageView.clipsToBounds = true
        contentView.addSubview(photoImageView)
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            photoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            photoImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            photoImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

extension PhotoCollectionViewCell {
    struct Model {
        let photo: Photo
    }
}
