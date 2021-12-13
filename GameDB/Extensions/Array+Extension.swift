//
//  Array+Extension.swift
//  GameDB
//
//  Created by Can Tekinalp on 13.12.2021.
//

import Foundation

extension Array {
    
    public subscript(safe index: Int) -> Element? {
        guard index >= 0, index < endIndex else {
            return nil
        }
        return self[index]
    }
}
