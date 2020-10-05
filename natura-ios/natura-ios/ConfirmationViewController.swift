//
//  ConfirmationViewController.swift
//  natura-ios
//
//  Created by livetouch on 05/10/20.
//  Copyright © 2020 livetouch. All rights reserved.
//

import UIKit

class ConfirmationViewController: UIViewController {

    @IBOutlet weak var sensorView: UIView!
    @IBOutlet weak var productStack: UIStackView!

    @IBOutlet weak var tfDe: TextField!
    @IBOutlet weak var tfEmail: TextField!
    @IBOutlet weak var tfPara: TextField!
    @IBOutlet weak var tfRelacao: TextField!
    @IBOutlet weak var tfMensagem: TextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }

    func setupViews() {
        let data = DataModel.shared.data

        guard let de = data.de, let para = data.para, let product = data.product, let relacao = data.relacao, let email = data.email, let mensagem = data.mensagem else {
            return
        }

        tfDe.text = de
        tfPara.text = para
        tfRelacao.text = relacao
        tfEmail.text = email
        tfMensagem.text = mensagem

        [tfRelacao, tfDe, tfEmail, tfPara, tfMensagem].compactMap { $0 as? UITextField }.forEach { tf in
            tf.isEnabled = false
            tf.layer.borderColor = UIColor(named: "yellow")!.cgColor
            tf.layer.borderWidth = 1
            tf.generateShadow()
        }

        sensorView.layer.cornerRadius = .defaultRadius * 2
        sensorView.layer.borderColor = UIColor(named: "yellow")!.cgColor
        sensorView.layer.borderWidth = 1
        sensorView.generateShadow()

        let nib = UINib(nibName: "ProductViewCell", bundle: nil)
        if var cell = nib.instantiate(withOwner: self, options: nil)[0] as? ProductViewCell {
            cell.isSelected = true
            cell.configure(product: product)
            cell.frame.size.height = sensorView.frame.height
            productStack.addArrangedSubview(cell)
        }
    }

    init() {
        super.init(nibName: "\(ConfirmationViewController.self)", bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
