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
                if let sb = d.cards?.filter({ ($0 as? DeckCard)?.isSideboard == false && ($0 as? DeckCard)?.isCommander == false}) as? [DeckCard]
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
    var CMCs: [Float] = []
    var sectionTitles = ["Rarity Breakdown", "Cost","CMC","Colors","Types"]
    override func viewDidLoad() {
        super.viewDidLoad()
        calculateRarities()
        calculateCMCs()
        deckCost = getPrices()
    }
    private func getPrices() -> Double {
        var total = 0.0
        var cardids = deckCards.map{
            $0.card?.tcgplayerProductID
        }.compactMap { $0 }
        print("With 0s: \(cardids)")
        cardids.removeAll(where: {$0 == 0})
        print("Without 0s: \(cardids)")
        TcgPlayerApi.handler.getPrices(for: cardids) { prices in
            for deckcard in self.deckCards {
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
            print(total)
            self.tableView.cellForRow(at: IndexPath(row: 0, section: 1))?.detailTextLabel?.text = total.currencyUS
        }
        
        return total
    }
    struct Rarities {
        var common = 0
        var uncommon = 0
        var rare = 0
        var mythic = 0
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
    
    private func calculateCMCs(){
        print("Deck Card Count: \(deckCards.count)")
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
        if indexPath.section != 1 {
            return 200
        }
        return 54
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "rarityCell", for: indexPath)
        if indexPath.section == 0 {
            let chart = UIHostingController(rootView: BarChart(bars: [
                Bar(id: UUID(), value: Double(rarities.common), label: "Common", color: Color("Common")),
                Bar(id: UUID(), value: Double(rarities.uncommon), label: "Uncommon", color: Color("Uncommon")),
                Bar(id: UUID(), value: Double(rarities.rare), label: "Rare", color: Color("Rare")),
                Bar(id: UUID(), value: Double(rarities.mythic), label: "Mythic", color: Color("Mythic"))]))
            
            
            chart.view.translatesAutoresizingMaskIntoConstraints = false
            chart.view.frame = cell.contentView.bounds
            cell.contentView.addSubview(chart.view)
        }
        else if indexPath.section == 2 {
            let chart = UIHostingController(rootView: BarChart(bars: createCMCBars()))
            
            chart.view.translatesAutoresizingMaskIntoConstraints = false
            chart.view.frame = cell.contentView.bounds
            cell.contentView.addSubview(chart.view)
        } else if indexPath.section == 3 {
            
            
            let chart = UIHostingController(rootView: SunburstView(configuration: createSunburstConfigForColor()))
            chart.view.translatesAutoresizingMaskIntoConstraints = false
            chart.view.frame = cell.contentView.bounds
            cell.contentView.addSubview(chart.view)
        } else if indexPath.section == 4 {
            
        } else if indexPath.section == 1 {
            cell.textLabel?.text = "TCGPlayer"
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
        
        
        
        let configuration = SunburstConfiguration(nodes: [Node(name: Int(W).description, value: W, backgroundColor: UIColor(named: "Plains") ),
        Node(name: Int(U).description, value: U, backgroundColor: UIColor(named: "Islands")),
        Node(name: Int(B).description, value: B, backgroundColor: UIColor(named: "Swamps")),
        Node(name: Int(R).description, value: R, backgroundColor: UIColor(named: "Mountains")),
        Node(name: Int(G).description, value: G, backgroundColor: UIColor(named: "Forests")),
        Node(name: Int(A).description, value: A, backgroundColor: UIColor(named: "Artifacts"))], calculationMode: .parentIndependent(totalValue: W+U+B+R+G+A))
        return configuration
    }
    private func createCMCBars() -> [Bar] {
        var bars: [Bar] = []
        let unique = CMCs.removingDuplicates().sorted()
        for cmc in unique {
            bars.append(Bar(id: UUID(), value: Double(CMCs.filter { $0 == cmc}.count), label: "\(cmc)", color: .gray))
            print(cmc)
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

