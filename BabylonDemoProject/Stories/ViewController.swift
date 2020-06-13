//
//  ViewController.swift
//  BabylonDemoProject
//
//  Created by Igor Kokoev on 11.06.2020.
//  Copyright © 2020 Igor Kokoev. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {

    @IBOutlet private weak var counterLabel: UILabel!
    private var counter = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        updateText()
    }
    @IBAction private func didTapHit(_ sender: Any) {
        counter += 1
        updateText()
    }

    func updateText() {
        counterLabel.text = "\(counter)"
    }
}
