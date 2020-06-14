//
//  PhotoCollectionViewCell.swift
//  BabylonDemoProject
//
//  Created by Igor Kokoev on 14.06.2020.
//  Copyright © 2020 Igor Kokoev. All rights reserved.
//

import UIKit
import Kingfisher

final class PhotoCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var photoImageView: UIImageView?

    override func awakeFromNib() {
        super.awakeFromNib()
        photoImageView?.clipsToBounds = true
    }

    func configure(with model: Model) {
        photoImageView?.kf.setImage(with: model.imageURL)
    }
}

extension PhotoCollectionViewCell {
    struct Model {
        let imageURL: URL
    }
}
