//
//  Model.swift
//  natura-ios
//
//  Created by livetouch on 04/10/20.
//  Copyright © 2020 livetouch. All rights reserved.
//

import Foundation

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

struct Product {
    var name : String
    var description : String
    var image: String
}

struct DataModel {
    static let shared: DataModel = DataModel()

    var data: [ProductCategory : [Product]] = [:]

    private init() {
        let cabelo = [
            Product(name: "Natura Lumina", description: "Shampoo/Condicionar", image: "lumina"),
            Product(name: "Natura Lumina", description: "Máscara de tratamento", image: "lumina"),
            Product(name: "Plant", description: "Shampoo/Condicionar", image: "lumina"),
            Product(name: "Plant", description: "Máscara de tratamento", image: "lumina"),
            Product(name: "Ekos Patauá", description: "Shampoo/Condicionar", image: "lumina")]

        self.data[.cabelo] = cabelo
    }
}
