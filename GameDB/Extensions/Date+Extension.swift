//
//  Date+Extension.swift
//  GameDB
//
//  Created by Can Tekinalp on 13.12.2021.
//

import Foundation

fileprivate let releaseDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "d MMMM yyyy"
    return formatter
}()

extension Date {
    
    var uiFormattedDate: String {
        return releaseDateFormatter.string(from: self)
    }
}
