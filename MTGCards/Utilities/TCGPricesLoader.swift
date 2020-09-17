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
}


