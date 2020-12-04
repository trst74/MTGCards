//
//  TCGPricesLoader.swift
//  MTGCards
//
//  Created by Joseph Smith on 9/9/20.
//  Copyright © 2020 Robotic Snail Software. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

class TCGPricesLoader: ObservableObject {
    
    var downloadedPrices: TcgPrices?
    let objectWillChange = PassthroughSubject<TCGPricesLoader?, Never>()
    
    func load(cardIds: [Int32]) {
        
        TcgPlayerApi.handler.getPrices(for: cardIds) { prices in
            self.downloadedPrices = prices
            self.objectWillChange.send(self)
        } 
        
    }
    func getTotal(deck: Deck?) -> Double {
        var total = 0.0
        if let d = deck {
            if let cards = d.cards {
                for deckcard in (cards.allObjects as? [DeckCard] ?? []) {
                    if let tcgid = deckcard.card?.tcgplayerProductID {
                        var subtype = "Normal"
                        if deckcard.isFoil {
                            subtype = "Foil"
                        }
                        let cardprices = self.downloadedPrices?.results.first(where: {$0.productID == tcgid && $0.subTypeName == subtype})
                        if let result = cardprices, let market = result.marketPrice {
                            total += (market * Double(deckcard.quantity))
                        }
                    }
                }
            }
        }
        return total
    }
}

