//
//  ParaphraseTests.swift
//  ParaphraseTests
//
//  Created by Brian Sipple on 3/17/19.
//  Copyright © 2019 Hacking with Swift. All rights reserved.
//

import XCTest

@testable import Paraphrase


class ParaphraseTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLoadingInitialQuotes() {
        let model = QuotesModel(isTesting: true)
        
        let expected = 12
        let actual = model.count
        
        XCTAssertEqual(actual, expected, "default quotes model does not have \(expected) quotes")
    }
    
    func testRandomQuoteSelection() {
        let model = QuotesModel(isTesting: true)
        
        guard let chosenQuote = model.random() else {
            XCTFail()
            return
        }
        
        let expected = "Eliot"
        let actual = chosenQuote.author
        
        XCTAssertEqual(actual, expected, "random quote")
    }
}


// MARK - Formatting

extension ParaphraseTests {

    func testMultilineFormatting() {
        let model = QuotesModel(isTesting: true)
        let quote = model.quote(at: 0)

        let expected = "\"\(quote.text)\"\n   — \(quote.author)"
        let actual = quote.multiLine
        
        XCTAssertEqual(actual, expected, "multi-line quote text does not have proper formatting.")
    }
    
    func testSingleLineFormatting() {
        let model = QuotesModel(isTesting: true)
        let quote = model.quote(at: 0)
        let formattedText = quote.text.replacingOccurrences(of: "\n", with: " ")
        
        let expected = "\(quote.author): \(formattedText)"
        let actual = quote.singleLine
        
        XCTAssertEqual(actual, expected, "single-line quote text does not have proper formatting.")
    }
    
    func testAttributedStringFormatting() {
        let model = QuotesModel(isTesting: true)
        let quote = model.quote(at: 0)
        
        XCTAssertNotNil(quote.attributedString, "quote does not provide an `attributedString` property")
    }
}
