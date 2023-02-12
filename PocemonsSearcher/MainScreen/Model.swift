//
//  Model.swift
//  PocemonsSearcher
//
//  Created by Егор Худяев on 07.02.2023.
//

import Foundation

    //MARK: - модель данных для одного покемона

struct Model : Codable {
    let name : String?
    let sprites : Sprites?

    enum CodingKeys: String, CodingKey {
        case name = "name"
        case sprites = "sprites"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        sprites = try values.decodeIfPresent(Sprites.self, forKey: .sprites)
    }
}

struct Sprites : Codable {
    let back_default : String?
    let back_female : String?
    let back_shiny : String?
    let back_shiny_female : String?
    let front_default : String?
    let front_female : String?
    let front_shiny : String?
    let front_shiny_female : String?

    enum CodingKeys: String, CodingKey {
        case back_default = "back_default"
        case back_female = "back_female"
        case back_shiny = "back_shiny"
        case back_shiny_female = "back_shiny_female"
        case front_default = "front_default"
        case front_female = "front_female"
        case front_shiny = "front_shiny"
        case front_shiny_female = "front_shiny_female"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        back_default = try values.decodeIfPresent(String.self, forKey: .back_default)
        back_female = try values.decodeIfPresent(String.self, forKey: .back_female)
        back_shiny = try values.decodeIfPresent(String.self, forKey: .back_shiny)
        back_shiny_female = try values.decodeIfPresent(String.self, forKey: .back_shiny_female)
        front_default = try values.decodeIfPresent(String.self, forKey: .front_default)
        front_female = try values.decodeIfPresent(String.self, forKey: .front_female)
        front_shiny = try values.decodeIfPresent(String.self, forKey: .front_shiny)
        front_shiny_female = try values.decodeIfPresent(String.self, forKey: .front_shiny_female)
    }
    
    func getNextItem(_ currentItem: Self.CodingKeys) -> String {
        switch currentItem {
        case .back_default:  return Self.CodingKeys.back_female.description
        case .back_female: return Sprites.CodingKeys.back_shiny.stringValue
        case .back_shiny: return Sprites.CodingKeys.back_shiny_female.stringValue
        case .back_shiny_female: return Sprites.CodingKeys.front_default.stringValue
        case .front_default: return Sprites.CodingKeys.front_female.stringValue
        case .front_female: return Sprites.CodingKeys.front_shiny.stringValue
        case .front_shiny: return Sprites.CodingKeys.front_shiny_female.stringValue
        case .front_shiny_female: return Sprites.CodingKeys.back_default.stringValue
        }
    }
}

    //MARK: - модель данных для списка всех покемонов

struct PocemonsWorld : Codable {
    let results : [Results]?

    enum CodingKeys: String, CodingKey {
        case results = "results"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        results = try values.decodeIfPresent([Results].self, forKey: .results)
    }
}

struct Results : Codable {
    let name : String?

    enum CodingKeys: String, CodingKey {
        case name = "name"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decodeIfPresent(String.self, forKey: .name)
    }
}

