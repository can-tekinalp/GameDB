//
//  FavoriteVM.swift
//  GameDB
//
//  Created by Can Tekinalp on 13.12.2021.
//

import Foundation

final class FavoriteVM {
    
    private var favoriteGames: [GameCollectionViewCellVM] = []
    
    var cellCount: Int {
        return favoriteGames.count
    }
    
    func cellViewModel(at indexPath: IndexPath) -> GameCollectionViewCellVM? {
        return favoriteGames[safe: indexPath.row]
    }
    
    func getFavoriteGames() {
        favoriteGames = UserDefaults.favoriteGames.map { GameCollectionViewCellVM(game: $0) }
    }
    
    func fetchGameDetails(id: Int, handler: @escaping (Result<GameDetails, String>) -> Void) {
        NetworkService.request(decodable: GameDetails.self, route: .getDetails(gameId: id), parameters: [:]) { result in
            switch result {
            case .success(let response):
                handler(.success(response))
            case .failure:
                handler(.failure(unexpectedError))
            }
        }
    }
}

extension UserDefaults {
    
    fileprivate static let key = "FavoriteGames"

    static var favoriteGames: [Game] {
        get {
            guard let data = UserDefaults.standard.object(forKey: key) as? Data else {
                return []
            }
            let decoder = JSONDecoder()
            guard let gameList = try? decoder.decode([Game].self, from: data) else {
                return []
            }
            return gameList
        }
        set {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .custom({ (date, encoder) in
                let formatter = apiDateFormatter
                let stringData = formatter.string(from: date)
                var container = encoder.singleValueContainer()
                try container.encode(stringData)
            })
            let data = try? encoder.encode(newValue)
            UserDefaults.standard.setValue(data, forKey: key)
        }
    }
    
    static func addFavoriteGame(_ game: Game) {
        var currentFavorites = favoriteGames
        currentFavorites.append(game)
        favoriteGames = currentFavorites
    }
    
    static func removeFavoriteGame(_ id: Int) -> Bool {
        var currentFavorites = favoriteGames
        guard let index = currentFavorites.firstIndex(where: { $0.id == id }) else {
            return false
        }
        currentFavorites.remove(at: index)
        favoriteGames = currentFavorites
        return true
    }
    
    
    static func isFavorite(id: Int) -> Bool {
        return favoriteGames.first(where: { $0.id == id }) != nil
    }
}
