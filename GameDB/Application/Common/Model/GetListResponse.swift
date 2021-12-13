//
//  GetListResponse.swift
//  GameDB
//
//  Created by Can Tekinalp on 12.12.2021.
//

import Foundation

struct GetListResponse: Decodable {
    let count: Int
    let next: URL?
    let results: [Game]
    
    enum CodingKeys: String, CodingKey {
        case count, next, results
    }
}
