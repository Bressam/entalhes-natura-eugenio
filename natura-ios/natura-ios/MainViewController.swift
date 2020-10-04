//
//  ViewController.swift
//  natura-ios
//
//  Created by livetouch on 04/10/20.
//  Copyright © 2020 livetouch. All rights reserved.
//

import UIKit

enum CreationState: Int {
    case product = 1
    case message
    case confirmation
    case engrave
    case done

    var next : CreationState {
        return CreationState(rawValue: self.rawValue + 1) ?? self
    }

    var previous : CreationState {
        return CreationState(rawValue: self.rawValue - 1) ?? self
    }

    var vc : UIViewController? {
        switch self {
        case .message:
            let vc = MessageViewController()
            return vc
        case .confirmation:
            let vc = UIViewController()
            vc.view.backgroundColor = .green
            return vc
        case .engrave:
            let vc = UIViewController()
            vc.view.backgroundColor = .orange
            return vc
        case .done:
            let vc = UIViewController()
            vc.view.backgroundColor = .red
            return vc
        default:
            return nil
        }
    }
}

class MainViewController: UIViewController {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var creationProgress: UIProgressView!
    @IBOutlet weak var stackStepsLabel: UIStackView!

    var stepsLabels : [UILabel] = []

    var childNavigation: UINavigationController?

    var state : CreationState = .product {
        didSet {
            updateState(oldState: oldValue)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        state = .product

        nextButton.addTarget(self, action: #selector(handleNextState), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(handlePreviousState), for: .touchUpInside)
    }

    @objc func handleNextState() {
        state = state.next
    }

    @objc func handlePreviousState() {
        state = state.previous
    }

    fileprivate func setupViews() {
        childNavigation = children.first as? UINavigationController

        stepsLabels = stackStepsLabel.arrangedSubviews.compactMap { $0 as? UILabel }
    }

    fileprivate func updateState(oldState: CreationState) {
        guard let childNavigation = childNavigation else { return }

        backButton.isHidden = state == .product

        for (index, label) in stepsLabels.enumerated() {
            if index < state.rawValue {
                label.textColor = UIColor(named: "orange") ?? .orange
            } else {
                label.textColor = UIColor.systemGray2
            }
        }

        creationProgress.progress = Float(state.rawValue) * 0.25

        if state == .confirmation {
            nextButton.setTitle("Confirmar", for: .normal)
        } else if state == .engrave {
            backButton.isHidden = true
            nextButton.isHidden = true
        } else {
            nextButton.setTitle("Próximo", for: .normal)
        }

        if oldState.rawValue > state.rawValue {
            childNavigation.popViewController(animated: true)
        } else {
            if let vc = state.vc {
                childNavigation.pushViewController(vc, animated: true)
            }
        }
    }

}

