//
//  QuotesModel.swift
//  ParaphraseTests
//
//  Created by Brian Sipple on 3/17/19.
//  Copyright © 2019 Hacking with Swift. All rights reserved.
//

import Foundation
import GameplayKit

struct QuotesModel {
    private var quotes: [Quote] = []
    var randomSource: GKRandomSource?

    init(isTesting: Bool = false) {
        quotes = loadQuotes(isTesting: isTesting)
        randomSource = isTesting ? GKMersenneTwisterRandomSource(seed: 1) : GKMersenneTwisterRandomSource()
    }
}


// MARK: - Computed Properties

extension QuotesModel {
    var count: Int {
        return quotes.count
    }
}


// MARK: - Core Methods

extension QuotesModel {
    
    func random() -> Quote? {
        guard !quotes.isEmpty else { return nil }
        
        let index = randomSource?.nextInt(upperBound: quotes.count) ?? 0
        
        return quotes[index]
    }
}


// MARK: - Private Helper Methods

private extension QuotesModel {
    
    func loadQuotes(isTesting: Bool) -> [Quote] {
        let defaults = UserDefaults.standard
        let quoteData : Data
        
        if !isTesting, let savedQuotes = defaults.data(forKey: "SavedQuotes") {
            // we have saved quotes; use them
            SwiftyBeaver.info("Loading saved quotes")
            quoteData = savedQuotes
        } else {
            // no saved quotes; load the default initial quotes
            SwiftyBeaver.info("No saved quotes")
            let path = Bundle.main.url(forResource: "initial-quotes", withExtension: "json")!
            quoteData = try! Data(contentsOf: path)
        }
        
        let decoder = JSONDecoder()
        return try! decoder.decode([Quote].self, from: quoteData)
    }
}
