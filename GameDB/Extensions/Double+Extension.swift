//
//  Double+Extension.swift
//  GameDB
//
//  Created by Can Tekinalp on 13.12.2021.
//

import Foundation

fileprivate let ratingFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.maximumFractionDigits = 2
    formatter.usesGroupingSeparator = false
    formatter.decimalSeparator = "."
    return formatter
}()

extension Double {
    
    var formattedRating: String {
        let number = NSNumber(value: self)
        return ratingFormatter.string(from: number) ?? " "
    }
}
