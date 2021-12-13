//
//  String+Extension.swift
//  GameDB
//
//  Created by Can Tekinalp on 13.12.2021.
//

import Foundation

extension String {
    
    var htmlAttributedString: NSAttributedString? {
        
        let htmlTemplate = """
        <!doctype html>
        <html>
          <head>
            <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
          </head>
          <body>
            \(self)
          </body>
        </html>
        """

        guard let data = htmlTemplate.data(using: .utf8) else {
            return nil
        }

        guard let attributedString = try? NSAttributedString(
            data: data,
            options: [
                .documentType: NSAttributedString.DocumentType.html,
                .characterEncoding: String.Encoding.utf8.rawValue
            ],
            documentAttributes: nil
        ) else {
            return nil
        }

        return attributedString
    }
}
