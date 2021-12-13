//
//  HomePageControllerVM.swift
//  GameDB
//
//  Created by Can Tekinalp on 13.12.2021.
//

import SDWebImage
import UIKit

final class HomePageControllerVM {
    
    private let games: [Game]
    private var pageViewModels: [PageVM] = []
    
    init(games: [Game]) {
        self.games = games
        self.pageViewModels = games.map { PageVM(game: $0) }
    }
    
    func pageViewModel(at index: Int) -> PageVM? {
        return pageViewModels[safe: index]
    }
}

final class PageVM {
    
    let game: Game
    var downloadedImage: UIImage?
        
    var imgURL: URL? {
        return game.backgroundImage
    }
    
    init(game: Game) {
        self.game = game
    }
    
    func fetchImg() {
        SDWebImageManager.shared.loadImage(with: imgURL) { [weak self] image in
            self?.downloadedImage = image
        }
    }
}
