//
//  Model.swift
//  natura-ios
//
//  Created by livetouch on 04/10/20.
//  Copyright © 2020 livetouch. All rights reserved.
//

import UIKit

enum SensorType: Int, Codable {
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

    var image: String {
        switch self {
        case .cabelo:
            return "c1_shampoo_patua"
        case .rosto:
            return "r1_agua_miscelar"
        case .perfumaria:
            return "p1_biografia"
        case .maquiagem:
            return "m1_pincel_blush_aquarela"
        default:
            return "p1_biografia"
        }
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

struct Product: Equatable, Codable {
    var name : String
    var description : String
    var image: String
}

class CreationData: Codable {
    var product: Product?
    var category: ProductCategory?
    var de: String?
    var para: String?
    var relacao: String?
    var email: String?
    var mensagem: String?
    var sensorTipo: SensorType?
    var machineId: Int = 0

    enum CodingKeys: String, CodingKey  {
        case de, para, relacao, email, mensagem, machineId
    }
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
            Product(name: "EKOS: Shampoo Patuá", description: "Shampoo/Condicionar", image: "c1_shampoo_patua"),
            Product(name: "LUMINA: Máscara fortificante cabelos crespos", description: "Máscara fortificante", image: "c2_lumina_mascara_cabelos_crespos"),
            Product(name: "LUMINA: Condicionador provitalidade", description: "Condicionador", image: "c3_condicionador_provitalidade"),
            Product(name: "EKOS: Shampoo Morumoru", description: "Shampoo", image: "c4_shampoo_morumoru"),
            Product(name: "PLANT: Condicionador hidratação reparadora", description: "Condicionador", image: "c5_condicionador_hidratacao_reparadora")]
        
        let maquiagem = [
            Product(name: "Aquarela: Pincel, pó e blush", description: "Pincel, pó e blush aquarela", image: "m1_pincel_blush_aquarela"),
            Product(name: "UNA - Base Matte", description: "Maquinagem", image: "m2_base_matte"),
            Product(name: "UNA: Maxxi Palette de sombras - 12 tons intensa una", description: "Paleta de sombras", image: "m3_paleta_maxxi")]
        
        let rosto = [
            Product(name: "CHRONOS: Água micelar purificante ", description: "Água micelar CHRONOS", image: "r1_agua_miscelar"),
            Product(name: "CHRONOS: Espuma de limpeza suave", description: "Espuma de limpeza CHRONOS", image: "r2_espuma_limpeza_suave"),
            Product(name: "CHRONOS: Sistema de tratamento antissinais", description: "Tratamento antissinais CHRONOS", image: "r3_tratamento_antissinais"),
            Product(name: "CHRONOS: Tônico Detox adstringente", description: "Tônico detox CHRONOS", image: "r4_tonico_detox_adistringente")]
        
        let perfumaria = [
            Product(name: "BIOGRAFIA: Perfume BIOGRAFIA feminino", description: "Perfume Feminino", image: "p1_biografia"),
            Product(name: "LUNA: Perfume LUNA intenso", description: "Perfume Feminino", image: "p2_luna"),
            Product(name: "Essencial Exclusivo", description: "Perfume Feminino", image: "p3_essencial_feminino"),
            Product(name: "Kaiak Aero", description: "Perfume Masculino", image: "p4_aero_masculino")]

        self.products[.cabelo] = cabelo
        self.products[.maquiagem] = maquiagem
        self.products[.rosto] = rosto
        self.products[.perfumaria] = perfumaria
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
            return ""
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
