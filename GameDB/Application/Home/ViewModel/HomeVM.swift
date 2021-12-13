//
//  HomeVM.swift
//  GameDB
//
//  Created by Can Tekinalp on 13.12.2021.
//

import Foundation

final class HomeVM {
    
    private(set) var pageControllerVM: HomePageControllerVM?
    private(set) var cellViewModels: [GameCollectionViewCellVM] = []
    private(set) var searchedCellViewModels: [GameCollectionViewCellVM] = []
    private var getListResponse: GetListResponse?
    var isSearching: Bool = false
    
    var cellCount: Int {
        return isSearching ? searchedCellViewModels.count : cellViewModels.count
    }
    
    func cellViewModel(at indexPath: IndexPath) -> GameCollectionViewCellVM? {
        return isSearching ? searchedCellViewModels[indexPath.row] : cellViewModels[indexPath.row]
    }
    
    func fetchInitialList(handler: @escaping () -> Void) {
        let parameters = [
            "dates": "2021-01-01,2021-12-31",
            "metacritic" : "80,100"
        ]
        
        NetworkService.request(decodable: GetListResponse.self, route: .getList, parameters: parameters) { [weak self] result in
            switch result {
            case .success(let response):
                self?.getListResponse = response
                self?.setupViewModels(games: response.results)
            case .failure:
                return
            }
            handler()
        }
    }
    
    private func setupViewModels(games: [Game]) {
        guard games.count > 3 else { return }
        pageControllerVM = HomePageControllerVM(games: Array(games[0..<3]))
        cellViewModels = Array(games[3...]).map { GameCollectionViewCellVM(game: $0) }
    }
    
    func fetchNext(handler: @escaping () -> Void) {
        guard let next = getListResponse?.next else { return }
        NetworkService.request(decodable: GetListResponse.self, route: .raw(next.absoluteString), parameters: [:]) { [weak self] result in
            switch result {
            case .success(let response):
                guard let self = self else { return }
                self.getListResponse = response
                self.addNewViewModels(newGames: response.results, handler: handler)
            case .failure:
                handler()
            }
        }
    }
    
    private func addNewViewModels(newGames: [Game], handler: @escaping () -> Void) {
        guard newGames.isEmpty == false else {
            handler()
            return
        }
        cellViewModels.append(contentsOf: newGames.map { GameCollectionViewCellVM(game: $0) })
        handler()
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
    
    func search(text: String) -> Bool {
        let result = cellViewModels.filter {
            return $0.name.localizedCaseInsensitiveContains(text)
        }
        searchedCellViewModels = result
        return result.isEmpty
    }
    
    func resetSearch() {
        searchedCellViewModels = []
    }
}
