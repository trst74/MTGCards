//
//  SearchResultsView.swift
//  MTGCards
//
//  Created by Joseph Smith on 5/29/21.
//

import SwiftUI
import CoreData



struct SearchResultsView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(
        // 2
        entity: Card.entity(),
        // 3
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Card.name, ascending: true)
        ]
        // 4
    ) var cards: FetchedResults<Card>
    
    var body: some View {
        List{
            ForEach(cards, id: \.self) { card in
                Text(card.name ?? "Name Failed")
            }
        }
    }
}


