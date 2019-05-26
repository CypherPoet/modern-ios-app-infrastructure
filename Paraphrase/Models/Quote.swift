//
//  Quote.swift
//  Paraphrase
//
//  Created by Paul Hudson on 05/05/2018.
//  Copyright © 2018 Hacking with Swift. All rights reserved.
//

import UIKit

struct Quote: Codable, Comparable {
    var author: String
    var text: String

    static func < (lhs: Quote, rhs: Quote) -> Bool {
        return lhs.author < rhs.author
    }
}


// MARK: - Computed Properties

extension Quote {
    var singleLine: String {
        let formattedText = text.replacingOccurrences(of: "\n", with: " ")
        
        return "\(author): \(formattedText)"
    }
    
    var multiLine: String {
        return "\"\(text)\"\n   — \(author)"
    }
    
    var attributedString: NSAttributedString {
        let finishedQuote = NSMutableAttributedString(string: text, attributes: quoteAttributes)
        let authorString = NSAttributedString(string: "\n\n\(author)", attributes: authorAttributes)
        
        finishedQuote.append(authorString)
        
        return finishedQuote
    }
    
    
    private var authorAttributes: [NSAttributedString.Key: Any] {
        var attributes: [NSAttributedString.Key: Any] = [:]
        
        if let authorFont = UIFont(name: "Georgia-Italic", size: 16) {
            let metrics = UIFontMetrics(forTextStyle: .body)
            attributes[.font] = metrics.scaledFont(for: authorFont)
        }
        
        return attributes
    }
    
    private var quoteAttributes: [NSAttributedString.Key: Any] {
        var attributes: [NSAttributedString.Key: Any] = [:]
        
        if let quoteFont = UIFont(name: "Georgia", size: 24) {
            let metrics = UIFontMetrics(forTextStyle: .body)
            attributes[.font] = metrics.scaledFont(for: quoteFont)
        }
        
        return attributes
    }
    
    
}
