//
//  DeckStatsView.swift
//  MTGCards
//
//  Created by Joseph Smith on 12/1/20.
//  Copyright © 2020 Robotic Snail Software. All rights reserved.
//

import SwiftUI

struct DeckStatsView: View {
    
    public var deck: Deck?
    @State var rarities = Rarities()
    @State var CMCs: [Float] = []
    
    var deckCards: [DeckCard] {
        get {
            if let d = deck {
                if let sb = d.cards?.filter({ ($0 as? DeckCard)?.isSideboard == false }) as? [DeckCard]
                {
                    return sb.sorted {
                        if let n1 = $0.card?.name, let n2 = $1.card?.name {
                            return n1 < n2
                        }
                        return false
                    }
                }
            }
            return []
        }
    }
    
    var body: some View {
        ScrollView{
            VStack(alignment: .leading) {
                VStack(alignment: .center) {
                    Text("Rarity Breakdown")
                        .padding(.top)
                    BarChart(bars: getRarityBars())
                        .onAppear {
                            calculateRarities()
                        }
                        .padding(.bottom)
                }
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(10)
                VStack(alignment: .center) {
                    Text("Cost")
                    .frame(minWidth: 0, maxWidth: .infinity)
                        .padding(.top)
                        .padding(.bottom, 5)
                    Text("$500.00")
                        .font(.title)
                        .padding(.bottom)
                }
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(10)
                VStack(alignment: .center) {
                    Text("CMC")
                        .padding(.top)
                    BarChart(bars: createCMCBars())
                        .onAppear {
                            calculateCMCs()
                        }
                        .padding(.bottom)
                }
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(10)
                VStack(alignment: .center) {
                    Text("Colors")
                        .padding(.top)
                    SunburstView(configuration: createSunburstConfigForColor())
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, idealHeight: 200, maxHeight: .infinity, alignment: .center)
                        .padding(.bottom)
                }
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(10)
                Text("Types")
                Text("Legalities")
            }
        }
        .navigationTitle(Text("Stats"))
        .padding()
    }
    private func createSunburstConfigForColor() -> SunburstConfiguration {
        
        var W = 0.0
        var U = 0.0
        var B = 0.0
        var R = 0.0
        var G = 0.0
        var A = 0.0
        
        for card in deckCards{
            if !(card.card?.type?.contains("Land") ?? true) {
                let quantity = Int(card.quantity)
                if let colorIdentities = card.card?.colorIdentity?.allObjects as? [ColorIdentity] {
                    let identities: [String?] = colorIdentities.map ({ $0.color })
                    if identities.contains("W") {
                        W += Double(quantity)
                    }
                    if identities.contains("U") {
                        U += Double(quantity)
                    }
                    if identities.contains("B") {
                        B += Double(quantity)
                    }
                    if identities.contains("R") {
                        R += Double(quantity)
                    }
                    if identities.contains("G") {
                        G += Double(quantity)
                    }
                    if identities.count == 0 {
                        A += Double(quantity)
                    }
                }
            }
        }
        
        var configuration = SunburstConfiguration(nodes: [])
        if W+U+B+R+G+A > 0 {
            configuration = SunburstConfiguration(nodes: [Node(name: Int(W).description, value: W, backgroundColor: UIColor(named: "Plains") ),
                                                          Node(name: Int(U).description, value: U, backgroundColor: UIColor(named: "Islands")),
                                                          Node(name: Int(B).description, value: B, backgroundColor: UIColor(named: "Swamps")),
                                                          Node(name: Int(R).description, value: R, backgroundColor: UIColor(named: "Mountains")),
                                                          Node(name: Int(G).description, value: G, backgroundColor: UIColor(named: "Forests")),
                                                          Node(name: Int(A).description, value: A, backgroundColor: UIColor(named: "Artifacts"))], calculationMode: .parentIndependent(totalValue: W+U+B+R+G+A))
        }
        return configuration
    }
    private func createCMCBars() -> [Bar] {
        var bars: [Bar] = []
        let unique = CMCs.removingDuplicates().sorted()
        for cmc in unique {
            bars.append(Bar(id: UUID(), value: Double(CMCs.filter { $0 == cmc}.count), label: "\(cmc)", color: .gray))
            //print(cmc)
        }
        return bars
    }
    private func calculateCMCs(){
        var temp: [Float?] = []
        for card in deckCards{
            if !(card.card?.type?.contains("Land") ?? true) {
                let quantity = Int(card.quantity)
                for _ in 1...quantity {
                    temp.append(card.card?.convertedManaCost)
                }
            }
        }
        for cmc in temp {
            if let tempcmc = cmc {
                CMCs.append(tempcmc)
            }
        }
    }
    private func getRarityBars() -> [Bar] {
        
        var bars: [Bar] = []
        if rarities.total != 0 {
            bars = [
                Bar(id: UUID(), value: Double(rarities.common), label: "Common", color: Color("Common")),
                Bar(id: UUID(), value: Double(rarities.uncommon), label: "Uncommon", color: Color("Uncommon")),
                Bar(id: UUID(), value: Double(rarities.rare), label: "Rare", color: Color("Rare")),
                Bar(id: UUID(), value: Double(rarities.mythic), label: "Mythic", color: Color("Mythic"))]
        }
        return bars
    }
    struct Rarities {
        var common = 0
        var uncommon = 0
        var rare = 0
        var mythic = 0
        var total: Int {
            get {
                return common + uncommon + rare + mythic
            }
        }
        
    }
    private func calculateRarities() {
        
        for card in deckCards{
            let quantity = Int(card.quantity)
            switch card.card?.rarity {
            case "common":
                rarities.common += quantity
                break
            case "uncommon":
                rarities.uncommon += quantity
                break
            case "rare":
                rarities.rare += quantity
                break
            case "mythic":
                rarities.mythic += quantity
                break
            default:
                break
            }
        }
    }
}

