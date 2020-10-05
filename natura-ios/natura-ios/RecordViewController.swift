//
//  RecordViewController.swift
//  natura-ios
//
//  Created by livetouch on 05/10/20.
//  Copyright © 2020 livetouch. All rights reserved.
//

import UIKit
import SoundWave



class RecordViewController: UIViewController {
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var againButton: UIButton!
    @IBOutlet weak var audioView: AudioVisualizationView!

    enum RecordState {
        case initial
        case recording
        case stop
        case play
    }

    var state: RecordState = .initial {
        didSet {
            updateState()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        updateState()
    }

    func setupViews() {
        actionButton.generateShadow()
        actionButton.addTarget(self, action: #selector(handleAction), for: .touchUpInside)
        againButton.addTarget(self, action: #selector(handleAgain), for: .touchUpInside)
    }

    func updateState() {
        if state == .initial {
            againButton.isHidden = true
            audioView.isHidden = true
            actionButton.setImage(UIImage(systemName: "mic.fill"), for: .normal)
        } else if state == .recording {
            againButton.isHidden = true
            actionButton.setImage(UIImage(systemName: "stop.fill"), for: .normal)
            audioView.isHidden = false
        } else if state == .stop {
            againButton.isHidden = false
            actionButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            audioView.isHidden = false
        } else if state == .play {
            audioView.isHidden = false
            againButton.isHidden = false
            actionButton.setImage(UIImage(systemName: "stop.fill"), for: .normal)
        }

    }

    @objc func handleAction() {
        if state == .initial {
            state = .recording
        } else if state == .recording {
            state = .stop
        } else if state == .stop {
            state = .play
        } else if state == .play {
            state = .stop
        }
    }

    @objc func handleAgain() {
        state = .initial
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        actionButton.layer.cornerRadius = actionButton.layer.frame.height/2
    }

    init() {
        super.init(nibName: "\(RecordViewController.self)", bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
