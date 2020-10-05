//
//  MessageViewController.swift
//  natura-ios
//
//  Created by livetouch on 04/10/20.
//  Copyright © 2020 livetouch. All rights reserved.
//

import UIKit

class MessageViewController: UIViewController {

    @IBOutlet weak var tfDe: TextField!
    @IBOutlet weak var tfEmail: TextField!
    @IBOutlet weak var tfPara: TextField!
    @IBOutlet weak var tfRelacao: TextField!
    @IBOutlet weak var tfMensagem: TextField!

    @IBOutlet var sensoresViews : [UIView] = []

    var sensorSelecionado: Int = 0

    var relacaoOpcoes: [String] = [
        "Amigos(as)",
        "Esposo(a)",
        "Namorado(a)",
        "Mãe/Pai",
        "Filho(a)",
        "Outro"
    ]

    let picker = UIPickerView()

    override func viewDidLoad() {
        super.viewDidLoad()

        picker.delegate = self
        picker.dataSource = self
        tfRelacao.inputView = picker

        sensoresViews.forEach { view in
            view.layer.cornerRadius = CGFloat.defaultRadius * 2
            view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSensorSelected(_:))))
        }

        atualizarSensor()
    }

    @objc func handleSensorSelected(_ gesture: UITapGestureRecognizer) {
        let tag = gesture.view?.tag ?? 0
        sensorSelecionado = tag
        atualizarSensor()
    }

    func atualizarSensor() {
        sensoresViews.forEach { view in
            if view.tag == sensorSelecionado {
                view.layer.borderColor = UIColor(named: "yellow")!.cgColor
                view.layer.borderWidth = 1
                view.generateShadow()
            } else {
                view.layer.borderWidth = 0
                view.generateShadow(color: UIColor.systemGray2)
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    init() {
        super.init(nibName: "\(MessageViewController.self)", bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension MessageViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return relacaoOpcoes.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return relacaoOpcoes[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        tfRelacao.text = relacaoOpcoes[row]
    }

}

