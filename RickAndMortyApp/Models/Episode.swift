//
//  Episode.swift
//  RickAndMortyApp
//
//  Created by Kirill Taraturin on 28.06.2023.
//

import Foundation

struct Episode: Codable {
    var name: String
    var airDate: String
    var episode: String
    var characters: [String]
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case airDate = "air_date"
        case episode = "episode"
        case characters = "characters"
    }
}
