//
//  ImageViewController.swift
//  GameDB
//
//  Created by Can Tekinalp on 12.12.2021.
//

import SDWebImage
import UIKit

protocol ImageViewControllerDelegate: AnyObject {
    func didTapImage(with viewModel: PageVM)
}

final class ImageViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    private var pageViewModel: PageVM?
    weak var delegate: ImageViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.addTapGesture(target: self, action: #selector(handleTap))
        imageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        imageView.image = pageViewModel?.downloadedImage
    }
    
    func configure(viewModel: PageVM?) {
        guard let viewModel = viewModel else { return }
        pageViewModel = viewModel
        guard self.isViewLoaded else {
            viewModel.fetchImg()
            return
        }
        imageView.sd_setImage(with: viewModel.imgURL) { [weak self] image, _, _, _ in
            self?.imageView.image = image            
        }
    }
    
    @objc private func handleTap() {
        guard let viewModel = pageViewModel else { return }
        delegate?.didTapImage(with: viewModel)
    }
}
