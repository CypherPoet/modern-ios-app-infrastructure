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
