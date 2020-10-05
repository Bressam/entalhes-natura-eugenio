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
    @IBOutlet weak var creationProgress: UIProgressView!
    @IBOutlet weak var stackStepsLabel: UIStackView!
    @IBOutlet weak var searchButton: UIButton!

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

        [backButton, nextButton, searchButton].forEach { bt in
            bt?.layer.cornerRadius = CGFloat.defaultRadius
            bt?.generateShadow()
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if let gradientImage = UIImage.gradientImage(with: creationProgress.frame, colors: [UIColor(named: "orange")!.cgColor, UIColor(named: "yellow")!.cgColor], locations: nil) {
            creationProgress.progressImage = gradientImage
            creationProgress.layer.cornerRadius = creationProgress.frame.height/2
            creationProgress.clipsToBounds = true

            creationProgress.layer.sublayers![1].cornerRadius = creationProgress.frame.height/2
            creationProgress.subviews[1].clipsToBounds = true

            creationProgress.layer.shadowPath = UIBezierPath(roundedRect: self.creationProgress.bounds, cornerRadius: creationProgress.frame.height/2).cgPath
            creationProgress.generateShadow()
            creationProgress.layer.masksToBounds = false
        }
    }

    fileprivate func updateState(oldState: CreationState) {
        guard let childNavigation = childNavigation else { return }

        backButton.isHidden = state == .product

        for (index, label) in stepsLabels.enumerated() {
            if index < state.rawValue {
                label.textColor = UIColor(named: "yellow") ?? .yellow
            } else {
                label.textColor = UIColor.systemGray2
            }
        }

        creationProgress.setProgress(Float(state.rawValue) * 0.25, animated: true)

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

