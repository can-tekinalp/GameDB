//
//  FavoriteViewController.swift
//  GameDB
//
//  Created by Can Tekinalp on 12.12.2021.
//

import UIKit

final class FavoriteViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var messageLabel: UILabel!
    private var viewModel = FavoriteVM()
    private var dummyCell: GameCollectionViewCell!

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        viewModel.getFavoriteGames()
        messageLabel.isHidden = viewModel.cellCount != 0
    }
    
    private func routeToDetails(game: Game, detail: GameDetails) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        let viewModel = DetailVM(game: game, details: detail)
        controller.setViewModel(viewModel: viewModel)
        present(controller, animated: true, completion: nil)
    }
    
    @objc private func handleFavoritesChangedNotification() {
        viewModel.getFavoriteGames()
        messageLabel.isHidden = viewModel.cellCount != 0
        collectionView.reloadData()
    }
}

// MARK: Setup
extension FavoriteViewController {
    
    private func setup() {
        collectionView.register(UINib(nibName: GameCollectionViewCell.cellId, bundle: nil), forCellWithReuseIdentifier: GameCollectionViewCell.cellId)
        let nib = Bundle.main.loadNibNamed("GameCollectionViewCell", owner: GameCollectionViewCell.self, options: nil)! as NSArray
        dummyCell = (nib.object(at: 0) as! GameCollectionViewCell)
        NotificationCenter.default.addObserver(self, selector: #selector(handleFavoritesChangedNotification), name: .FavoritesChanged, object: nil)
    }
}

extension FavoriteViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.cellCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GameCollectionViewCell.cellId, for: indexPath) as! GameCollectionViewCell
        cell.configure(viewModel.cellViewModel(at: indexPath))
        return cell
    }
}

extension FavoriteViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cellViewModel = viewModel.cellViewModel(at: indexPath) else { return }
        viewModel.fetchGameDetails(id: cellViewModel.game.id) { [weak self] result in
            switch result {
            case .success(let detail):
                self?.routeToDetails(game: cellViewModel.game, detail: detail)
            case .failure:
                self?.showOkAlert("Hata", unexpectedError)
            }
        }
    }
}

extension FavoriteViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let viewModel = viewModel.cellViewModel(at: indexPath) else {
            return .zero
        }
        let sectionInset = (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.sectionInset
        let widthToSubtract = sectionInset!.left + sectionInset!.right
        let requiredWidth = collectionView.bounds.size.width
        let sizeToFit = CGSize(width: requiredWidth, height: 0)
        dummyCell.configure(viewModel)
        let targetSize = dummyCell.systemLayoutSizeFitting(sizeToFit)
        return CGSize(width: (self.collectionView?.bounds.width)! - widthToSubtract, height: targetSize.height)
    }
}
