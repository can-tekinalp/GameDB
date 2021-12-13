//
//  GameDetails.swift
//  GameDB
//
//  Created by Can Tekinalp on 13.12.2021.
//

import Foundation

struct GameDetails: Decodable {
    let id: Int
    let name: String
    let metacritic: Int
    let backgroundImage: URL?
    let released: Date?
    let description: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, metacritic, released, description
        case backgroundImage = "background_image"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        metacritic = try container.decode(Int.self, forKey: .metacritic)
        backgroundImage = try? container.decode(URL.self, forKey: .backgroundImage)
        description = try container.decode(String.self, forKey: .description)
        guard let dateString = try? container.decode(String.self, forKey: .released),
              let date = apiDateFormatter.date(from: dateString) else {
            released = nil
            return
        }
        released = date
    }
}
