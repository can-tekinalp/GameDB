//
//  UITextField+Extension.swift
//  GameDB
//
//  Created by Can Tekinalp on 13.12.2021.
//

import UIKit

extension UITextField {
    
    func addCancelButtonToKeyboard(title: String = "İptal", target: Any? = nil, action: Selector? = nil) {
        let toolBar = UIToolbar()
        let spaceButton = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil
        )
        let doneButton = UIBarButtonItem(
            title: title,
            style: .plain,
            target: target ?? self,
            action: action ?? #selector(resign)
        )
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.sizeToFit()
        inputAccessoryView = toolBar
    }
    
    @objc fileprivate func resign() {
        resignFirstResponder()
    }
}
