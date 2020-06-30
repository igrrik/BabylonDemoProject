//
//  UIViewController+Error.swift
//  BabylonDemoProject
//
//  Created by Igor Kokoev on 01.07.2020.
//  Copyright © 2020 Igor Kokoev. All rights reserved.
//

import UIKit

protocol ErrorPresentable {
    func show(_ error: Error)
}

extension ErrorPresentable where Self: UIViewController {
    func show(_ error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}
