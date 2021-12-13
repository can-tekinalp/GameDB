//
//  GameCollectionViewCellVM.swift
//  GameDB
//
//  Created by Can Tekinalp on 13.12.2021.
//

import SDWebImage
import UIKit

final class GameCollectionViewCellVM {

    let game: Game
    
    var name: String {
        return game.name
    }
    
    var details: String {
        return "\(game.rating.formattedRating) - \(game.released?.uiFormattedDate ?? "")"
    }
    
    var imgURL: URL? {
        return game.backgroundImage
    }

    init(game: Game) {
        self.game = game
    }
}
