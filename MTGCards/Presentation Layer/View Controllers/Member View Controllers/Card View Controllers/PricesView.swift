//
//  PricesView.swift
//  MTGCards
//
//  Created by Joseph Smith on 9/17/20.
//  Copyright © 2020 Robotic Snail Software. All rights reserved.
//
import Foundation
import SwiftUI

struct PricesView: View {
    
    @ObservedObject private var pricesLoader = TCGPricesLoader()
    
    var placeholder = PricesPlaceholderView()
    var card: Card
    init(cardIDs: [Int32], card: Card) {
        self.card = card
        self.pricesLoader.load(cardIds: cardIDs)
    }
    
    var body: some View {
        if let prices = self.pricesLoader.downloadedPrices {
            return AnyView(PricesResultsView(hasNonFoil: card.hasNonFoil, hasFoil: card.hasFoil, prices: prices))
        } else {
            return AnyView(placeholder)
        }
    }
    
}

struct PricesResultsView: View {
    var hasNonFoil: Bool
    var hasFoil: Bool
    var prices: TcgPrices
    var normal: Result? {
        get {
            return prices.results.first(where: {$0.subTypeName == "Normal" })
        }
    }
    var foil: Result? {
        get {
            return prices.results.first(where: {$0.subTypeName == "Foil" })
        }
    }
    var body: some View {
        VStack{
            Text("TCGPlayer Prices")
            HStack{
                Text("").font(.system(size: 11.0, weight: .regular))
                    .frame(minWidth: 0,
                           maxWidth: .infinity,
                           minHeight: 0,
                           maxHeight: 20)
                Text("Low").font(.system(size: 11.0, weight: .regular))
                    .frame(minWidth: 0,
                           maxWidth: .infinity,
                           minHeight: 0,
                           maxHeight: 20)
                Text("Mid").font(.system(size: 11.0, weight: .regular))
                    .frame(minWidth: 0,
                           maxWidth: .infinity,
                           minHeight: 0,
                           maxHeight: 20)
                Text("Market").font(.system(size: 11.0, weight: .regular))
                    .frame(minWidth: 0,
                           maxWidth: .infinity,
                           minHeight: 0,
                           maxHeight: 20)
            }
            if hasNonFoil {
                HStack{
                    Text("Normal").font(.system(size: 11.0, weight: .regular))
                        .frame(minWidth: 0,
                               maxWidth: .infinity,
                               minHeight: 0,
                               maxHeight: 20)
                    Text("\(normal?.lowPrice?.currencyUS ?? "-")").font(.system(size: 10.0, weight: .regular))
                        .frame(minWidth: 0,
                               maxWidth: .infinity,
                               minHeight: 0,
                               maxHeight: 20)
                    Text("\(normal?.midPrice?.currencyUS ?? "-")").font(.system(size: 10.0, weight: .regular))
                        .frame(minWidth: 0,
                               maxWidth: .infinity,
                               minHeight: 0,
                               maxHeight: 20)
                    Text("\(normal?.marketPrice?.currencyUS ?? "-")").font(.system(size: 10.0, weight: .regular))
                        .frame(minWidth: 0,
                               maxWidth: .infinity,
                               minHeight: 0,
                               maxHeight: 20)
                }
            }
            if hasFoil {
                HStack{
                    Text("Foil").font(.system(size: 11.0, weight: .regular))
                        .frame(minWidth: 0,
                               maxWidth: .infinity,
                               minHeight: 0,
                               maxHeight: 20)
                    Text("\(foil?.lowPrice?.currencyUS ?? "-")").font(.system(size: 10.0, weight: .regular))
                        .frame(minWidth: 0,
                               maxWidth: .infinity,
                               minHeight: 0,
                               maxHeight: 20)
                    Text("\(foil?.midPrice?.currencyUS ?? "-")").font(.system(size: 10.0, weight: .regular))
                        .frame(minWidth: 0,
                               maxWidth: .infinity,
                               minHeight: 0,
                               maxHeight: 20)
                    Text("\(foil?.marketPrice?.currencyUS ?? "-")").font(.system(size: 10.0, weight: .regular))
                        .frame(minWidth: 0,
                               maxWidth: .infinity,
                               minHeight: 0,
                               maxHeight: 20)
                }
            }
        }
        .padding(.init(top: 8.0, leading: 16.0, bottom: 8.0, trailing: 16.0))
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(10)
    }
}
struct PricesPlaceholderView: View {
    var body: some View {
        Text("Prices not avaliable")
    }
}
