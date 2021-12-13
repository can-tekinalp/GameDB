//
//  UIViewController+Extension.swift
//  GameDB
//
//  Created by Can Tekinalp on 13.12.2021.
//

import UIKit

extension UIViewController {
    
    func showOkAlert(_ title: String, _ message: String) {
        let okAction = UIAlertAction(title: "Tamam", style: .default, handler: nil)
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(okAction)
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
