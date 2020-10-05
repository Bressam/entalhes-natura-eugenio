//
//  DoneViewController.swift
//  natura-ios
//
//  Created by livetouch on 05/10/20.
//  Copyright © 2020 livetouch. All rights reserved.
//

import UIKit

class DoneViewController: UIViewController {

    @IBOutlet weak var againButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        againButton.generateShadow()
        againButton.layer.cornerRadius = .defaultRadius
    }


    @IBAction func handleAgain(_ sender: Any) {
        navigationController?.mainViewController?.handleNextState()
    }

    init() {
        super.init(nibName: "\(Self.self)", bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
