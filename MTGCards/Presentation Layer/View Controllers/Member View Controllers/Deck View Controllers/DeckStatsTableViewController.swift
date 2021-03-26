//
//  DeckStatsTableViewController.swift
//  MTGCards
//
//  Created by Joseph Smith on 6/9/19.
//  Copyright © 2019 Robotic Snail Software. All rights reserved.
//

import UIKit
import CoreData
import SwiftUI

class DeckStatsTableViewController: UITableViewController {
    
    var deckCost = 0.0
    var deck: Deck? = nil
    var rarities = Rarities()
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
    var commander: DeckCard? {
        get {
            if let d = deck {
                if let c = d.cards?.first(where: { ($0 as? DeckCard)?.isCommander == true }) as? DeckCard
                {
                    return c
                }
            }
            return nil
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

    var CMCs: [Float] = []
    var sectionTitles = ["Rarity Breakdown", "Cost","CMC","Colors","Types","Legalities"]
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        calculateRarities()
        calculateCMCs()
        deckCost = getPrices()
        
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
    private func getPrices() -> Double {
        var total = 0.0
        var cardids = deckCards.map{
            $0.card?.tcgplayerProductID
        }.compactMap { $0 }

        cardids.removeAll(where: {$0 == 0})

        TcgPlayerApi.handler.getPrices(for: cardids) { prices in
            for deckcard in self.allCards {
                if let tcgid = deckcard.card?.tcgplayerProductID {
                    var subtype = "Normal"
                    if deckcard.isFoil {
                        subtype = "Foil"
                    }
                    let cardprices = prices.results.first(where: {$0.productID == tcgid && $0.subTypeName == subtype})
                    if let result = cardprices, let market = result.marketPrice {
                        total += (market * Double(deckcard.quantity))
                    }
                }
            }

            self.tableView.cellForRow(at: IndexPath(row: 0, section: 1))?.detailTextLabel?.text = total.currencyUS
        }
        
        return total
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
        if commander && self.commander != nil && self.sideboard.count == 0 && self.getCardCount() == 100 {
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
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return sectionTitles.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 5 {
            return 400
        }
        if indexPath.section != 1 {
            return 200
        }
        return 54
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "rarityCell", for: indexPath)
        if indexPath.section == 0 {
            var bars: [Bar] = []
            if rarities.total != 0 {
                bars = [
                    Bar(id: UUID(), value: Double(rarities.common), label: "Common", color: Color("Common")),
                    Bar(id: UUID(), value: Double(rarities.uncommon), label: "Uncommon", color: Color("Uncommon")),
                    Bar(id: UUID(), value: Double(rarities.rare), label: "Rare", color: Color("Rare")),
                    Bar(id: UUID(), value: Double(rarities.mythic), label: "Mythic", color: Color("Mythic"))]
            }
            let chart = UIHostingController(rootView: BarChart(bars: bars))
            
            
            chart.view.translatesAutoresizingMaskIntoConstraints = false
            chart.view.frame = cell.contentView.bounds
            cell.contentView.addSubview(chart.view)
            let margins = cell.contentView.safeAreaLayoutGuide
            NSLayoutConstraint.activate([
                chart.view.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
                chart.view.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
                chart.view.topAnchor.constraint(equalTo: margins.topAnchor),
                chart.view.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -20.0)
            ])
        }
        else if indexPath.section == 2 {
            let chart = UIHostingController(rootView: BarChart(bars: createCMCBars()))
            
            chart.view.translatesAutoresizingMaskIntoConstraints = false
            chart.view.frame = cell.contentView.bounds
            cell.contentView.addSubview(chart.view)
            let margins = cell.contentView.safeAreaLayoutGuide
            NSLayoutConstraint.activate([
                chart.view.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
                chart.view.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
                chart.view.topAnchor.constraint(equalTo: margins.topAnchor),
                chart.view.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -20.0)
            ])
        } else if indexPath.section == 3 {
            
            
            let chart = UIHostingController(rootView: SunburstView(configuration: createSunburstConfigForColor()))
            chart.view.translatesAutoresizingMaskIntoConstraints = false
            chart.view.frame = cell.contentView.bounds
            cell.contentView.addSubview(chart.view)
            let margins = cell.contentView.safeAreaLayoutGuide
            NSLayoutConstraint.activate([
                chart.view.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
                chart.view.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
                chart.view.topAnchor.constraint(equalTo: margins.topAnchor),
                chart.view.bottomAnchor.constraint(equalTo: margins.bottomAnchor)
            ])
        } else if indexPath.section == 4 {
            
        } else if indexPath.section == 1 {
            cell.textLabel?.text = "TCGPlayer"
            if deckCards.count == 0 {
                cell.detailTextLabel?.text = "--"
            }
        } else if indexPath.section == 5 {
            let legalities = UIHostingController(rootView: DeckLegalities(formats: calculateLegalities()))
            legalities.view.translatesAutoresizingMaskIntoConstraints = false
            legalities.view.frame = cell.contentView.bounds
            cell.contentView.addSubview(legalities.view)
            let margins = cell.contentView.safeAreaLayoutGuide
            NSLayoutConstraint.activate([
                legalities.view.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
                legalities.view.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
                legalities.view.topAnchor.constraint(equalTo: margins.topAnchor),
                legalities.view.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -20.0)
            ])
        }
        return cell
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
        }
        return bars
    }
}

extension DeckStatsTableViewController {
    static func refreshDeckStats(id: NSManagedObjectID) -> DeckStatsTableViewController {
        let storyboard = UIStoryboard(name: "DeckStats", bundle: nil)
        guard let deckstats = storyboard.instantiateInitialViewController() as? DeckStatsTableViewController else {
            fatalError("Project config error - storyboard doesnt provide a FileListVC")
        }
        if let d = CoreDataStack.handler.privateContext.object(with: id) as? Deck {
            deckstats.deck = d
            deckstats.title = "Stats"
        }
        return deckstats
    }
}

