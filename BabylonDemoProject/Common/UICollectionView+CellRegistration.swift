//
//  UICollectionView+CellRegistration.swift
//  BabylonDemoProject
//
//  Created by Igor Kokoev on 16.06.2020.
//  Copyright © 2020 Igor Kokoev. All rights reserved.
//

import UIKit

extension UICollectionViewCell: Reusable {}

extension UICollectionView {
    func registerCellOfType(_ cellType: Reusable.Type) {
        register(cellType, forCellWithReuseIdentifier: cellType.reuseId)
    }

    func dequeueReusableCell<CellType: UICollectionViewCell>(for indexPath: IndexPath) -> CellType {
        guard let cell = dequeueReusableCell(withReuseIdentifier: CellType.reuseId, for: indexPath) as? CellType else {
            fatalError("Failed dequeue cell with type \(CellType.description())")
        }
        return cell
    }
}
