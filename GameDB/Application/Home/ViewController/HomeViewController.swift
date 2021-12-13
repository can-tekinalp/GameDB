//
//  HomeViewController.swift
//  GameDB
//
//  Created by Can Tekinalp on 12.12.2021.
//

import UIKit

final class HomeViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewPrimaryTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionViewSecondaryTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var messageLabel: UILabel!
    
    private weak var homePageViewController: HomePageViewController?
    private let viewModel = HomeVM()
    private var dummyCell: GameCollectionViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        fetchInitialList()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toHomePageViewController" { 
            let destination = segue.destination as! HomePageViewController
            destination.homPageViewControllerDelegate = self
            homePageViewController = destination
        }
    }
}

// MARK: Setup
extension HomeViewController {
    
    private func setup() {
        collectionView.register(UINib(nibName: GameCollectionViewCell.cellId, bundle: nil), forCellWithReuseIdentifier: GameCollectionViewCell.cellId)
        pageControl.numberOfPages = HomePageViewController.pageCount
        let nib = Bundle.main.loadNibNamed("GameCollectionViewCell", owner: GameCollectionViewCell.self, options: nil)! as NSArray
        dummyCell = (nib.object(at: 0) as! GameCollectionViewCell)
        searchBar.delegate = self
        searchBar.searchTextField.addCancelButtonToKeyboard()
    }
}

// MARK: Helper Methods
extension HomeViewController {
    
    private func fetchInitialList() {
        viewModel.fetchInitialList { [weak self] in
            guard let self = self else { return }
            guard self.viewModel.cellCount > 0 else {
                self.pageControl.alpha = 0
                self.homePageViewController?.view.alpha = 0
                return
            }
            self.collectionView.reloadData()
            self.homePageViewController?.setViewModel(self.viewModel.pageControllerVM)
        }
    }
    
    private func fetchDetails(game: Game) {
        viewModel.fetchGameDetails(id: game.id) { [weak self] result in
            switch result {
            case .success(let detail):
                self?.routeToDetails(game: game, detail: detail)
            case .failure:
                self?.showOkAlert("Hata", unexpectedError)
            }
        }
    }
    
    private func routeToDetails(game: Game, detail: GameDetails) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        let viewModel = DetailVM(game: game, details: detail)
        controller.setViewModel(viewModel: viewModel)
        present(controller, animated: true, completion: nil)
    }
    
    private func changeState(isSearching: Bool) {
        if isSearching && viewModel.isSearching == false {
            viewModel.isSearching = true
            self.collectionViewPrimaryTopConstraint.priority = .defaultLow
            self.collectionViewSecondaryTopConstraint.priority = .required
            collectionView.reloadData()
        } else if !isSearching && viewModel.isSearching {
            viewModel.isSearching = false
            self.collectionViewSecondaryTopConstraint.priority = .defaultLow
            self.collectionViewPrimaryTopConstraint.priority = .required
            collectionView.reloadData()
        }
    }
}

extension HomeViewController: UISearchBarDelegate {
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        changeState(isSearching: false)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard searchText.count > 2 else {
            if viewModel.isSearching {
                messageLabel.isHidden = true
                viewModel.resetSearch()
                collectionView.reloadData()
            }
            return
        }
        changeState(isSearching: true)
        let isSearhcResultEmpty = viewModel.search(text: searchText)
        messageLabel.isHidden = !isSearhcResultEmpty
        collectionView.reloadData()
    }
}


extension HomeViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.cellCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GameCollectionViewCell.cellId, for: indexPath) as! GameCollectionViewCell
        cell.configure(viewModel.cellViewModel(at: indexPath))
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cellViewModel = viewModel.cellViewModel(at: indexPath) else { return }
        fetchDetails(game: cellViewModel.game)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let totalCellCount = viewModel.cellCount
        if indexPath.row == totalCellCount - 1 {
            viewModel.fetchNext { [weak self] in
                self?.collectionView.reloadData()
            }
        }
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {

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

extension HomeViewController: HomePageViewControllerDelegate {
    
    func didScrollTo(_ index: Int) {
        pageControl.currentPage = index
    }
    
    func shouldRouteToDetail(_ viewModel: PageVM) {
        fetchDetails(game: viewModel.game)
    }
}
