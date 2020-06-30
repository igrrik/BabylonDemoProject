//
//  LoadingIndicatorView.swift
//  BabylonDemoProject
//
//  Created by Igor Kokoev on 01.07.2020.
//  Copyright © 2020 Igor Kokoev. All rights reserved.
//

import UIKit

final class LoadingIndicatorView: UIActivityIndicatorView {
    var isVisible: Bool = true {
        didSet {
            if isVisible {
                startAnimating()
            } else {
                stopAnimating()
            }
        }
    }
}
