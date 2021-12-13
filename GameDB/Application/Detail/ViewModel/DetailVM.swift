//
//  DetailViewModel.swift
//  GameDB
//
//  Created by Can Tekinalp on 13.12.2021.
//

import Foundation

final class DetailVM {

    let game: Game
    private let gameDetails: GameDetails
    
    var name: String {
        return gameDetails.name
    }
    
    var releaseDate: String {
        return gameDetails.released?.uiFormattedDate ?? ""
    }
    
    var metacritic: String {
        return "\(gameDetails.metacritic)"
    }
    
    var description: NSAttributedString? {
        return gameDetails.description.htmlAttributedString
    }
    
    var imgURL: URL? {
        return gameDetails.backgroundImage
    }
    
    var isFavorite: Bool = false
    
    init(game: Game, details: GameDetails) {
        self.game = game
        self.gameDetails = details
        self.isFavorite = UserDefaults.isFavorite(id: gameDetails.id)
    }
    
    func toggleIsFavorite() -> Bool {
        defer {
            isFavorite = UserDefaults.isFavorite(id: gameDetails.id)
            NotificationCenter.default.post(name: .FavoritesChanged, object: nil)
        }
        if isFavorite {
            let result = UserDefaults.removeFavoriteGame(gameDetails.id)
            return result
        } else {
            UserDefaults.addFavoriteGame(game)
            return true
        }
    }
}
