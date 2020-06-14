//
//  PhotoCollectionViewCell.swift
//  BabylonDemoProject
//
//  Created by Igor Kokoev on 14.06.2020.
//  Copyright © 2020 Igor Kokoev. All rights reserved.
//

import UIKit

final class PhotoCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var photoImageView: UIImageView?

    func configure(with model: Model) {
        contentView.backgroundColor = model.backgroundColor
    }
}

extension PhotoCollectionViewCell {
    struct Model {
        let backgroundColor: UIColor
    }
}
