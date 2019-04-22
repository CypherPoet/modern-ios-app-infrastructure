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
    
}


// MARK: - Loading

extension ParaphraseTests {

    func testLoadingInitialQuotes() {
        let viewModel = QuotesViewModel(isTesting: true)
        
        let expected = 12
        let actual = viewModel.count
        
        XCTAssertEqual(actual, expected, "default quotes model does not have \(expected) quotes")
    }
}


// MARK: - `QuotesModel` methods

extension ParaphraseTests {
    
    func testRandomQuoteSelection() {
        let viewModel = QuotesViewModel(isTesting: true)
        
        guard let chosenQuote = viewModel.random() else {
            XCTFail()
            return
        }
        
        let expected = "Eliot"
        let actual = chosenQuote.author
        
        XCTAssertEqual(actual, expected, "random quote")
    }
    
    
    func testAddingQuote() {
        var viewModel = QuotesViewModel(isTesting: true)
        let startingQuoteCount = viewModel.count
        
        let newQuote = Quote(author: "Mario", text: "It's me!")
        viewModel.add(newQuote)
        
        let countDiff = viewModel.count - startingQuoteCount
        
        XCTAssertEqual(countDiff, 1, "quote count did not increase by one")
    }
    
    
    func testRemovingQuote() {
        var viewModel = QuotesViewModel(isTesting: true)
        let startingQuoteCount = viewModel.count
        
        viewModel.remove(at: 0)
        
        let countDiff = viewModel.count - startingQuoteCount
        
        XCTAssertEqual(countDiff, -1, "quote count did not decrease by one")
    }
    
    
    func testReplacingQuote() {
        var viewModel = QuotesViewModel(isTesting: true)
        let startingQuoteCount = viewModel.count
        let newQuote = Quote(author: "Mario", text: "It's me!")

        viewModel.replace(quoteAt: 0, with: newQuote)
        
        let countDiff = viewModel.count - startingQuoteCount
        XCTAssertEqual(countDiff, 0, "quote count changed after replacing")
        
        let addedQuote = viewModel.quote(at: 0)
        XCTAssertEqual(newQuote, addedQuote, "added quote is not the same as the quote use for replacement")
    }
    
}


// MARK - `Quote` Formatting

extension ParaphraseTests {

    func testMultilineFormatting() {
        let viewModel = QuotesViewModel(isTesting: true)
        let quote = viewModel.quote(at: 0)

        let expected = "\"\(quote.text)\"\n   — \(quote.author)"
        let actual = quote.multiLine
        
        XCTAssertEqual(actual, expected, "multi-line quote text does not have proper formatting.")
    }
    
    func testSingleLineFormatting() {
        let viewModel = QuotesViewModel(isTesting: true)
        let quote = viewModel.quote(at: 0)
        let formattedText = quote.text.replacingOccurrences(of: "\n", with: " ")
        
        let expected = "\(quote.author): \(formattedText)"
        let actual = quote.singleLine
        
        XCTAssertEqual(actual, expected, "single-line quote text does not have proper formatting.")
    }
    
    func testAttributedStringFormatting() {
        let viewModel = QuotesViewModel(isTesting: true)
        let quote = viewModel.quote(at: 0)
        
        XCTAssertNotNil(quote.attributedString, "quote does not provide an `attributedString` property")
    }
}


