//
//  ViewController.swift
//  BabylonDemoProject
//
//  Created by Igor Kokoev on 11.06.2020.
//  Copyright © 2020 Igor Kokoev. All rights reserved.
//

import UIKit
import Combine

final class ViewController: UIViewController {

    @IBOutlet private weak var counterLabel: UILabel!
    private var counter = 0
    private let apiClient = APIWorker()
    private var subscribtions = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        updateText()
    }
    @IBAction private func didTapHit(_ sender: Any) {
        counter += 1
        updateText()

        apiClient
            .send(request: ObtainAlbum(albumId: counter))
            .sink(receiveCompletion: {
                print($0)
            }, receiveValue: {
                print($0)
            })
            .store(in: &subscribtions)
    }

    func updateText() {
        counterLabel.text = "\(counter)"
    }
}
