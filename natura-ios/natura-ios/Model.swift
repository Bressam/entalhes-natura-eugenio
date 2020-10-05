//
//  Model.swift
//  natura-ios
//
//  Created by livetouch on 04/10/20.
//  Copyright © 2020 livetouch. All rights reserved.
//

import UIKit

enum SensorType: Int {
    case voice = 0
    case heartBeat
    case fingerprint
    case none
}

enum ProductCategory: String, Codable {
    case cabelo
    case perfumaria
    case maquiagem
    case rosto

    var title : String {
        return self.rawValue.capitalizingFirstLetter()
    }

    var description: String {
        switch self {
        case .cabelo:
            return "Shampoos, condicinadores e máscaras"
        case .perfumaria:
            return "Desodorantes e Deo corporais"
        case .maquiagem:
            return "Pó compacto"
        case .rosto:
            return "Tratamento"
        }
    }
}

struct Product: Equatable {
    var name : String
    var description : String
    var image: String
}

class CreationData {
    var product: Product?
    var category: ProductCategory?
    var de: String?
    var para: String?
    var relacao: String?
    var email: String?
    var mensagem: String?
    var sensorTipo: SensorType?
}


protocol CreationDelegate {
    func updateData()
}

struct DataModel {
    static let shared: DataModel = DataModel()

    var products: [ProductCategory : [Product]] = [:]
    var data: CreationData = CreationData()

    private init() {
        let cabelo = [
            Product(name: "Natura Lumina", description: "Shampoo/Condicionar", image: "lumina"),
            Product(name: "Natura Lumina", description: "Máscara de tratamento", image: "lumina"),
            Product(name: "Plant", description: "Shampoo/Condicionar", image: "lumina"),
            Product(name: "Plant", description: "Máscara de tratamento", image: "lumina"),
            Product(name: "Ekos Patauá", description: "Shampoo/Condicionar", image: "lumina")]

        let maquiagem = [
            Product(name: "Natura", description: "Batom", image: "lumina")
        ]

        self.products[.cabelo] = cabelo
        self.products[.maquiagem] = maquiagem
    }
}

enum CreationState: Int {
    case product = 1
    case message
    case record
    case confirmation
    case engrave
    case done

    var title: String {
        switch self {
        case .product:
            return "Qual produto você vai presentear?"
        case .message:
            return "Que tipo de mensagem você quer gravar?"
        case .record:
            return "Gravar mensagem"
        case .confirmation:
            return "Estamos quase lá, confirme as informações abaixo!"
        case .engrave:
            return "Mais um pouquinho..."
        case .done:
            return "Tudo pronto!"
        }
    }

    var next : CreationState {
        if self == .done {
            return .product
        }
        
        return CreationState(rawValue: self.rawValue + 1) ?? self
    }

    var previous : CreationState {
        return CreationState(rawValue: self.rawValue - 1) ?? self
    }

    var progress : Float {
        switch self {
        case .product:
            return 0.25
        case .message, .record:
            return 0.5
        case .confirmation:
            return 0.75
        default:
            return 1
        }
    }

    var vc : UIViewController? {
        switch self {
        case .message:
            let vc = MessageViewController()
            return vc
        case .record:
            let vc = RecordViewController()
            return vc
        case .confirmation:
            let vc = ConfirmationViewController()
            return vc
        case .engrave:
            let vc = EngravingViewController()
            return vc
        case .done:
            let vc = DoneViewController()
            return vc
        default:
            return nil
        }
    }
}
