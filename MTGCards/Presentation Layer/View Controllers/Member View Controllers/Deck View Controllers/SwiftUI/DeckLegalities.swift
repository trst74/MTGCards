//
//  DeckLegalities.swift
//  MTGCards
//
//  Created by Joseph Smith on 6/12/20.
//  Copyright © 2020 Robotic Snail Software. All rights reserved.
//

import SwiftUI

struct DeckLegalities: View {
    var formats: [Format]
    
    var body: some View {
        VStack {
            ForEach(formats, id: \.self) { format in
                HStack {
                    Text("\(format.name) : ")
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 35, alignment: .trailing)
                    Text("\(format.legality)")
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 35, alignment: .leading)
                }
                    
                .background(format.backgroundColor)
                .cornerRadius(10)
                .padding(4)
            }
            
        }
    .padding()
        .background(Color(UIColor.systemBackground))
    }
    
    init(formats: [Format]){
        self.formats = formats
    }
}
struct Format: Hashable{
    var name: String
    var legality: String
    var backgroundColor: Color {
        get {
            if legality == "Legal" {
                return Color(UIColor.Identity.Forests)
            }
            if legality == "Banned" {
                return Color(UIColor.Identity.Mountains)
            }
            
            if legality == "Restricted" {
                return Color(UIColor.Identity.Islands)
            }
            return Color(UIColor.systemFill)
        }
    }
}
struct DeckLegalities_Previews: PreviewProvider {
    static var previews: some View {
        DeckLegalities(formats: [
            Format(name: "Standard", legality: "Legal"),
            Format(name: "Pioneer", legality: "Not Legal"),
            Format(name: "Modern", legality: "Banned"),
            Format(name: "Legacy", legality: "Restricted"),
        Format(name: "Vintage", legality: "Legal"),
        Format(name: "Commander", legality: "Legal"),
        Format(name: "Frontier", legality: "Legal"),
        Format(name: "Pauper", legality: "Legal"),
        Format(name: "Penny", legality: "Legal"),
        Format(name: "Duel", legality: "Legal"),
        ])
            .environment(\.colorScheme, .dark)
    }
}
