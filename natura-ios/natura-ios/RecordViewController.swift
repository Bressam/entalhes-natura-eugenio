//
//  RecordViewController.swift
//  natura-ios
//
//  Created by livetouch on 05/10/20.
//  Copyright © 2020 livetouch. All rights reserved.
//

import UIKit
import AudioKit
import AudioKitUI

class RecordViewController: UIViewController {
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var againButton: UIButton!
    @IBOutlet weak var audioView: EZAudioPlot!

    var mic : AKMicrophone!
    var micTracker : AKMicrophoneTracker!
    var tracker: AKFrequencyTracker!
    var silence: AKBooster!
    var plot : AKNodeOutputPlot!

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

    func setupPlot() {
        plot = AKNodeOutputPlot(tracker, frame: audioView.bounds)
        plot.backgroundColor = .clear
        plot.plotType = .rolling
        plot.shouldFill = true
        plot.shouldMirror = true
        plot.gain = 10
        plot.color = UIColor(named: "yellow")
        audioView.addSubview(plot)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        AKSettings.audioInputEnabled = true

        AKSettings.sampleRate = AKManager.engine.inputNode.inputFormat(forBus: 0).sampleRate

        mic = AKMicrophone()
        tracker = AKFrequencyTracker(mic)
        silence = AKBooster(tracker, gain: 0)

        setupPlot()

        setupViews()
        updateState()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        AKManager.output = silence

        AKSettings.defaultToSpeaker = true
        AKSettings.audioInputEnabled = true

        do {
            try AKManager.start()
        } catch {
            AKLog("AudioKit did not start!")
        }
    }


    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        do {
            try AKManager.stop()
            AKManager.output = nil
        } catch {
            AKLog("AudioKit did not start!")
        }
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
            plot.pause()
            plot.redraw()
            plot.node = nil
        } else if state == .recording {
            againButton.isHidden = true
            actionButton.setImage(UIImage(systemName: "stop.fill"), for: .normal)
            audioView.isHidden = false
            plot.node = mic
            plot.resume()
        } else if state == .stop {
            plot.pause()
            againButton.isHidden = false
            actionButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            audioView.isHidden = false
        } else if state == .play {
            plot.resume()
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
