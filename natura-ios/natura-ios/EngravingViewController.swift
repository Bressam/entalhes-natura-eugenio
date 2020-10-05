//
//  EngravingViewController.swift
//  natura-ios
//
//  Created by livetouch on 05/10/20.
//  Copyright © 2020 livetouch. All rights reserved.
//

import UIKit

class EngravingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { timer in
            self.navigationController?.mainViewController?.handleNextState()
        }
    }

    init() {
        super.init(nibName: "\(Self.self)", bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
