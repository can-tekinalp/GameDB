//
//  Game.swift
//  GameDB
//
//  Created by Can Tekinalp on 12.12.2021.
//

import Foundation

let apiDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter
}()

struct Game: Codable {
    let id: Int
    let name: String
    let rating: Double
    let backgroundImage: URL?
    let released: Date?

    enum CodingKeys: String, CodingKey {
        case id, name, rating, released
        case backgroundImage = "background_image"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        rating = try container.decode(Double.self, forKey: .rating)
        backgroundImage = try? container.decode(URL.self, forKey: .backgroundImage)
        guard let dateString = try? container.decode(String.self, forKey: .released),
              let date = apiDateFormatter.date(from: dateString) else {
            released = nil
            return
        }
        released = date
    }
}
