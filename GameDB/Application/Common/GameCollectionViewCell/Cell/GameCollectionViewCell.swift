//
//  GameCollectionViewCell.swift
//  GameDB
//
//  Created by Can Tekinalp on 12.12.2021.
//

import SDWebImage
import UIKit

final class GameCollectionViewCell: UICollectionViewCell {

    static let cellId = "GameCollectionViewCell"
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    private var viewModel: GameCollectionViewCellVM?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.autoresizingMask = [.flexibleHeight]
        imageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
    }
    
    override func layoutSubviews() {
        self.layoutIfNeeded()
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        var targetSize = targetSize
        targetSize.height = CGFloat.greatestFiniteMagnitude
        let size = super.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
        return size
    }
    
    func configure(_ viewModel: GameCollectionViewCellVM?) {
        guard let viewModel = viewModel else { return }
        titleLabel.text = viewModel.name
        detailLabel.text =  viewModel.details
        imageView.sd_cancelCurrentImageLoad()
        imageView.sd_setImage(with: viewModel.imgURL) { [weak self] image, _, _, _ in
            self?.imageView.image = image
        }
    }
}
