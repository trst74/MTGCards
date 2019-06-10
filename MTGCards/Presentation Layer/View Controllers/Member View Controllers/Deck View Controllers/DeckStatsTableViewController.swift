//
//  DeckStatsTableViewController.swift
//  MTGCards
//
//  Created by Joseph Smith on 6/9/19.
//  Copyright © 2019 Robotic Snail Software. All rights reserved.
//

import UIKit
import CoreData

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
    var sectionTitles = ["Rarity Breakdown", "Cost","CMC","Colors","Types"]
    override func viewDidLoad() {
        super.viewDidLoad()
        calculateRarities()
        deckCost = getPrices()
    }
    private func getPrices() -> Double {
        var total = 0.0
        var cardids = deckCards.map{
            $0.card?.tcgplayerProductID
            }.compactMap { $0 }
        cardids.removeAll(where: {$0 == 0})
        TcgPlayerApi.handler.getPrices(for: cardids) { prices in
            var markettotal = 0.0
            for deckcard in self.deckCards {
                if let tcgid = deckcard.card?.tcgplayerProductID {
                    var subtype = "Normal"
                    if deckcard.isFoil {
                        subtype = "Foil"
                    }
                    let cardprices = prices.results.first(where: {$0.productID == tcgid && $0.subTypeName == subtype})
                    if let result = cardprices {
                        total += (result.marketPrice ?? 0.0 * Double(deckcard.quantity))
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
        if section == 0 {
            return 4
        } else if section == 4 {
            return 2
        } else {
            return 1
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "rarityCell", for: indexPath)
            var title = ""
            var count = 0
            switch indexPath.row {
            case 0:
                title = "Common"
                count = rarities.common
                break
            case 1:
                title = "Uncommon"
                count = rarities.uncommon
                break
            case 2:
                title = "Rare"
                count = rarities.rare
                break
            case 3:
                title = "Mythic"
                count = rarities.mythic
                break
            default:
                break
            }
            cell.textLabel?.text = title
            cell.detailTextLabel?.text = "\(count)"
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "rarityCell", for: indexPath)
        return cell
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
