//
//  UIView+Extension.swift
//  GameDB
//
//  Created by Can Tekinalp on 13.12.2021.
//

import UIKit

extension UIView {
    
    func addTapGesture(target: Any?, action: Selector?) {
        isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: target, action: action)
        self.addGestureRecognizer(tapGesture)
    }
}
