//
//  DetailViewController.swift
//  GameDB
//
//  Created by Can Tekinalp on 13.12.2021.
//

import SDWebImage
import UIKit

final class DetailViewController: UIViewController {
    
    private static let emptyHeartIcon = UIImage(systemName: "heart")
    private static let filledHeartIcon = UIImage(systemName: "heart.fill")
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var metacriticLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    private var viewModel: DetailVM!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setViewModel(viewModel: DetailVM) {
        self.viewModel = viewModel
    }
    
    @IBAction func didTapFavoriteButton(_ sender: Any) {
        let isSuccess = viewModel.toggleIsFavorite()
        if isSuccess {
            updateButtonState()
        } else {
            showOkAlert("Hata", unexpectedError)
        }
    }
    
    private func updateButtonState() {
        let icon = viewModel.isFavorite ? DetailViewController.filledHeartIcon : DetailViewController.emptyHeartIcon
        favoriteButton.setImage(icon, for: .normal)
    }
}

// MARK: Setup
extension DetailViewController {
    
    private func setup() {
        favoriteButton.imageEdgeInsets = .zero
        guard let viewModel = viewModel else { return }
        nameLabel.text = viewModel.name
        releaseDateLabel.text = viewModel.releaseDate
        metacriticLabel.text = viewModel.metacritic
        descriptionTextView.attributedText = viewModel.description
        imageView.sd_setImage(with: viewModel.imgURL) { [weak self] image, _, _, _ in
            self?.imageView.image = image
        }
        updateButtonState()
    }
}
