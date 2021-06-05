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
    @State var cardTypes = CardTypes()
    
    @ObservedObject private var pricesLoader = TCGPricesLoader()
    
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
    var allCards: [DeckCard] {
        get {
            if let d = deck {
                if let cards = d.cards {
                    return cards.allObjects as? [DeckCard] ?? []
                }
            }
            return []
        }
    }
    var mainboard: [DeckCard] {
        get {
            if let d = deck {
                if let sb =  d.cards?.filter({ ( $0 as? DeckCard)?.isSideboard == false && ($0 as? DeckCard)?.isCommander == false }) as? [DeckCard]
                {
                    return sb
                }
            }
            return []
        }
    }
    var sideboard: [DeckCard] {
        get {
            if let d = deck {
                if let sb =  d.cards?.filter({ ( $0 as? DeckCard)?.isSideboard == true }) as? [DeckCard]
                {
                    return sb
                }
            }
            return []
        }
    }
    var commanders: [DeckCard] {
        get {
            if let d = deck {
                if let c = d.cards?.filter({ ($0 as? DeckCard)?.isCommander == true }) as? [DeckCard]
                {
                    return c
                }
            }
            return []
        }
    }
    
    init(deck: Deck?) {
        self.deck = deck
        var ids = allCards.map{
            $0.card?.tcgplayerProductID
        }.compactMap { $0 }
        ids.removeAll(where: {$0 == 0})
        if deckCards.count > 0 {
            self.pricesLoader.load(cardIds: ids)
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
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
                        if deckCards.count > 0 {
                            Text(self.pricesLoader.getTotal(deck: self.deck).currency)
                                .font(.title)
                                .padding(.bottom)
                        } else {
                            Text(0.00.currency)
                                .font(.title)
                                .padding(.bottom)
                        }
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
                    
                    
                    if geometry.size.width > 600 {
                        HStack {
                            ColorsView(deckCards: deckCards)
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 100,  maxHeight: .infinity, alignment: .center)
                            TypesView(deckCards: deckCards)
                        }
                        
                    } else {
                        ColorsView(deckCards: deckCards)
                        TypesView(deckCards: deckCards)
                    }
                    
                    VStack {
                        Text("Legalities")
                            .padding(.top)
                        if deckCards.count > 0 {
                            DeckLegalities(formats: calculateLegalities())
                                .padding([.bottom, .leading, .trailing])
                        } else {
                            Text("There is no data to display.")
                                .italic()
                                .frame(maxWidth: .infinity)
                                .padding()
                        }
                    }
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(10)
                    
                }
                .padding()
            }
            .navigationTitle(Text("Stats"))
        }
    }
    private func calculateTypes() {
        cardTypes = CardTypes()
        for card in deckCards {
            if card.card?.type?.contains("Land") ?? false {
                cardTypes.land += Int(card.quantity)
            }
            if card.card?.type?.contains("Creature") ?? false {
                cardTypes.creature += Int(card.quantity)
            }
            if card.card?.type?.contains("Artifact") ?? false {
                cardTypes.artifact += Int(card.quantity)
            }
            if card.card?.type?.contains("Enchantment") ?? false {
                cardTypes.enchantment += Int(card.quantity)
            }
            if card.card?.type?.contains("Instant") ?? false {
                cardTypes.instant += Int(card.quantity)
            }
            if card.card?.type?.contains("Sorcery") ?? false {
                cardTypes.sorcery += Int(card.quantity)
            }
            if card.card?.type?.contains("Planeswalker") ?? false {
                cardTypes.planeswalker += Int(card.quantity)
            }
        }
    }
    struct CardTypes {
        var land = 0
        var creature = 0
        var artifact = 0
        var enchantment = 0
        var instant = 0
        var sorcery = 0
        var planeswalker = 0
        var total: Int {
            get {
                return land + creature + artifact + enchantment + instant + sorcery + planeswalker
            }
        }
        
    }
    private func createTypeBars() -> [Bar] {
        var bars: [Bar] = []
        if rarities.total != 0 {
            bars = [
                Bar(id: UUID(), value: Double(cardTypes.land), label: "Land", color: .gray),
                Bar(id: UUID(), value: Double(cardTypes.creature), label: "Creature", color: .gray),
                Bar(id: UUID(), value: Double(cardTypes.artifact), label: "Artifact", color: .gray),
                Bar(id: UUID(), value: Double(cardTypes.enchantment), label: "Enchantment", color: .gray),
                Bar(id: UUID(), value: Double(cardTypes.instant), label: "Instant", color: .gray),
                Bar(id: UUID(), value: Double(cardTypes.sorcery), label: "Sorcery", color: .gray),
                Bar(id: UUID(), value: Double(cardTypes.planeswalker), label: "Planeswalker", color: .gray)
            ]
        }
        return bars
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
    private func createSunburstConfigForType() -> SunburstConfiguration {
        
        
        
        var configuration = SunburstConfiguration(nodes: [])
        
        configuration = SunburstConfiguration(nodes: [Node(name: cardTypes.land.description, value: Double(cardTypes.land), backgroundColor: .blue ),
                                                      Node(name: cardTypes.creature.description, value: Double(cardTypes.creature), backgroundColor: .green ),
                                                      Node(name: cardTypes.artifact.description, value: Double(cardTypes.artifact), backgroundColor: .gray ),
                                                      Node(name: cardTypes.enchantment.description, value: Double(cardTypes.enchantment), backgroundColor: .orange ),
                                                      Node(name: cardTypes.instant.description, value: Double(cardTypes.instant), backgroundColor: .red ),
                                                      Node(name: cardTypes.sorcery.description, value: Double(cardTypes.sorcery), backgroundColor: .yellow ),
                                                      Node(name: cardTypes.planeswalker.description, value: Double(cardTypes.planeswalker), backgroundColor: .black )
        ], calculationMode: .parentIndependent(totalValue: Double(cardTypes.total)))
        
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
        CMCs = []
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
        rarities = Rarities()
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
    private func calculateLegalities() -> [Format] {
        var formats: [Format] = []
        let standard = allCards.allSatisfy({ $0.card?.legalities?.standard == "Legal"})
        if standard {
            formats.append(Format(name: "Standard", legality: "Legal"))
        } else {
            formats.append(Format(name: "Standard", legality: "Not Legal"))
        }
        let pioneer = allCards.allSatisfy({ $0.card?.legalities?.pioneer == "Legal"})
        if pioneer {
            formats.append(Format(name: "Pioneer", legality: "Legal"))
        } else {
            formats.append(Format(name: "Pioneer", legality: "Not Legal"))
        }
        let modern = allCards.allSatisfy({ $0.card?.legalities?.modern == "Legal"})
        if modern {
            formats.append(Format(name: "Modern", legality: "Legal"))
        } else {
            formats.append(Format(name: "Modern", legality: "Not Legal"))
        }
        let legacy = allCards.allSatisfy({ $0.card?.legalities?.legacy == "Legal"})
        if legacy {
            formats.append(Format(name: "Legacy", legality: "Legal"))
        } else {
            formats.append(Format(name: "Legacy", legality: "Not Legal"))
        }
        let vintage = allCards.allSatisfy({ $0.card?.legalities?.vintage == "Legal"})
        if vintage {
            formats.append(Format(name: "Vintage", legality: "Legal"))
        } else {
            formats.append(Format(name: "Vintage", legality: "Not Legal"))
        }
        let commander = allCards.allSatisfy({ $0.card?.legalities?.commander == "Legal"})
        var commanderColorID: [String] = []
        for com in self.commanders {
            commanderColorID.append(contentsOf: com.card?.colorIdentity?.allObjects.compactMap({($0 as? ColorIdentity)?.color}) ?? [])
        }
        var otherColorID: [String] = []
        for c in self.mainboard {
            otherColorID.append(contentsOf: c.card?.colorIdentity?.allObjects.compactMap({($0 as? ColorIdentity)?.color}) ?? [])
        }
        let isColorIDValid = otherColorID.allSatisfy( {commanderColorID.contains($0)} )
        if commander && (self.commanders.count > 0 && self.commanders.count < 3) && self.sideboard.count == 0 && self.getCardCount() == 100 && isColorIDValid {
            formats.append(Format(name: "Commmander", legality: "Legal"))
        } else {
            formats.append(Format(name: "Commander", legality: "Not Legal"))
        }
        let frontier = allCards.allSatisfy({ $0.card?.legalities?.frontier == "Legal"})
        if frontier {
            formats.append(Format(name: "Frontier", legality: "Legal"))
        } else {
            formats.append(Format(name: "Frontier", legality: "Not Legal"))
        }
        let pauper = allCards.allSatisfy({ $0.card?.legalities?.pauper == "Legal"})
        if pauper {
            formats.append(Format(name: "Pauper", legality: "Legal"))
        } else {
            formats.append(Format(name: "Pauper", legality: "Not Legal"))
        }
        let penny = allCards.allSatisfy({ $0.card?.legalities?.penny == "Legal"})
        if penny {
            formats.append(Format(name: "Penny", legality: "Legal"))
        } else {
            formats.append(Format(name: "Penny", legality: "Not Legal"))
        }
        let duel = allCards.allSatisfy({ $0.card?.legalities?.duel == "Legal"})
        if duel {
            formats.append(Format(name: "Duel", legality: "Legal"))
        } else {
            formats.append(Format(name: "Duel", legality: "Not Legal"))
        }
        return formats
    }
    private func getCardCount() -> Int {
        let cardTotal = deck?.cards?.reduce(0){
            if let c2 = $1 as? DeckCard {
                if let q0 = $0 {
                    let q2 = Int(c2.quantity)
                    return q0 + q2
                }
            }
            return 0
        }
        if let total = cardTotal {
            return total
        } else {
            return 0
        }
    }
}

struct ColorsView: View {
    var deckCards: [DeckCard]
    
    var body: some View {
        VStack(alignment: .center) {
            Text("Colors")
                .padding(.top)
            SunburstView(configuration: createSunburstConfigForColor())
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, idealHeight: 200, maxHeight: .infinity, alignment: .center)
                .padding(.bottom)
        }
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(10)
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
}
struct TypesView: View {
    @State var cardTypes = CardTypes()
    var deckCards: [DeckCard]
    var body: some View {
        VStack(alignment: .center) {
            Text("Types")
                .padding(.top)
            HStack (alignment: .center) {
                SunburstView(configuration: createSunburstConfigForType(deckCards: deckCards))
                    .onAppear {
                        calculateTypes()
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, idealHeight: 200, maxHeight: .infinity, alignment: .center)
                    .padding([.bottom, .leading])
                if deckCards.count > 0 {
                    VStack(alignment: .leading) {
                        HStack {
                            Circle()
                                .foregroundColor(.blue)
                                .frame(width: 15, height: 15, alignment: .center)
                            Text("Land - \(cardTypes.land.description)")
                                .font(.system(size: 10))
                        }
                        HStack {
                            Circle()
                                .foregroundColor(.green)
                                .frame(width: 15, height: 15, alignment: .center)
                            Text("Creature - \(cardTypes.creature.description)")
                                .font(.system(size: 10))
                        }
                        HStack {
                            Circle()
                                .foregroundColor(.gray)
                                .frame(width: 15, height: 15, alignment: .center)
                            Text("Artifact - \(cardTypes.artifact.description)")
                                .font(.system(size: 10))
                        }
                        HStack {
                            Circle()
                                .foregroundColor(.orange)
                                .frame(width: 15, height: 15, alignment: .center)
                            Text("Enchantment - \(cardTypes.enchantment.description)")
                                .font(.system(size: 10))
                        }
                        HStack {
                            Circle()
                                .foregroundColor(.red)
                                .frame(width: 15, height: 15, alignment: .center)
                            Text("Instant - \(cardTypes.instant.description)")
                                .font(.system(size: 10))
                        }
                        HStack {
                            Circle()
                                .foregroundColor(.yellow)
                                .frame(width: 15, height: 15, alignment: .center)
                            Text("Sorcery - \(cardTypes.sorcery.description)")
                                .font(.system(size: 10))
                        }
                        HStack {
                            Circle()
                                .foregroundColor(.black)
                                .frame(width: 15, height: 15, alignment: .center)
                            Text("Planeswalker - \(cardTypes.planeswalker.description)")
                                .font(.system(size: 10))
                        }
                    }
                    .frame(minWidth: 0, maxWidth: 150, minHeight: 0,  maxHeight: .infinity, alignment: .leading)
                    
                    .padding(.bottom)
                }
            }
        }
        
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(10)
    }
    private func createSunburstConfigForType(deckCards: [DeckCard]) -> SunburstConfiguration {
        
        
        
        var configuration = SunburstConfiguration(nodes: [])
        
        if deckCards.count > 0 {
            configuration = SunburstConfiguration(nodes: [Node(name: cardTypes.land.description, value: Double(cardTypes.land), backgroundColor: .blue ),
                                                          Node(name: cardTypes.creature.description, value: Double(cardTypes.creature), backgroundColor: .green ),
                                                          Node(name: cardTypes.artifact.description, value: Double(cardTypes.artifact), backgroundColor: .gray ),
                                                          Node(name: cardTypes.enchantment.description, value: Double(cardTypes.enchantment), backgroundColor: .orange ),
                                                          Node(name: cardTypes.instant.description, value: Double(cardTypes.instant), backgroundColor: .red ),
                                                          Node(name: cardTypes.sorcery.description, value: Double(cardTypes.sorcery), backgroundColor: .yellow ),
                                                          Node(name: cardTypes.planeswalker.description, value: Double(cardTypes.planeswalker), backgroundColor: .black )
            ], calculationMode: .parentIndependent(totalValue: Double(cardTypes.total)))
        }
        return configuration
    }
    private func calculateTypes() {
        cardTypes = CardTypes()
        for card in deckCards {
            if card.card?.type?.contains("Land") ?? false {
                cardTypes.land += Int(card.quantity)
            }
            if card.card?.type?.contains("Creature") ?? false {
                cardTypes.creature += Int(card.quantity)
            }
            if card.card?.type?.contains("Artifact") ?? false {
                cardTypes.artifact += Int(card.quantity)
            }
            if card.card?.type?.contains("Enchantment") ?? false {
                cardTypes.enchantment += Int(card.quantity)
            }
            if card.card?.type?.contains("Instant") ?? false {
                cardTypes.instant += Int(card.quantity)
            }
            if card.card?.type?.contains("Sorcery") ?? false {
                cardTypes.sorcery += Int(card.quantity)
            }
            if card.card?.type?.contains("Planeswalker") ?? false {
                cardTypes.planeswalker += Int(card.quantity)
            }
        }
    }
    struct CardTypes {
        var land = 0
        var creature = 0
        var artifact = 0
        var enchantment = 0
        var instant = 0
        var sorcery = 0
        var planeswalker = 0
        var total: Int {
            get {
                return land + creature + artifact + enchantment + instant + sorcery + planeswalker
            }
        }
        
    }
}
