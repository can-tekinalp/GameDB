//
//  SDWebImageManager+Extension.swift
//  GameDB
//
//  Created by Can Tekinalp on 13.12.2021.
//

import SDWebImage

extension SDWebImageManager {
    
    func loadImage(with imgURL: URL?, handler: @escaping (UIImage?) -> Void) {
        SDWebImageManager.shared.loadImage(with: imgURL, progress: nil) { image, _, _, _, _, _ in
            handler(image)
        }
    }
}
