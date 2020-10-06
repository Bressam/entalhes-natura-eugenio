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

        let service = RESTUtils()
        let data = DataModel.shared.data
        service.sendCreation(body: data) { result in
            switch result {
            case .success(let data):
                print(data)
                self.navigationController?.mainViewController?.handleNextState()
            case .failure(let exception):
                print(exception)
                self.navigationController?.mainViewController?.handleNextState()
            }
        }
    }

    init() {
        super.init(nibName: "\(Self.self)", bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
