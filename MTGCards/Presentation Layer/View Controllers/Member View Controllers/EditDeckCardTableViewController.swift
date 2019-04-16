//
//  EditDeckCardTableViewController.swift
//  MTGCards
//
//  Created by Joseph Smith on 4/13/19.
//  Copyright © 2019 Robotic Snail Software. All rights reserved.
//

import UIKit
import CoreData

class EditDeckCardTableViewController: UITableViewController {
    let sectionNames = ["Quatity","Sideboard", "Set"]
    var deckCard: DeckCard?
    var printings: [Card] = []
    var deckViewController: DeckTableViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getOtherPrintings()
        if let name = deckCard?.card?.name {
            self.title = name
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParent {
            print("save")
            saveDeckCard()
        }
    }
    func saveDeckCard(){
        if let quantityCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? DeckCardQuantityTableViewCell {
            deckCard?.quantity = Int16(quantityCell.quantityStepper.value)
        }
        if let sideboardCell = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? DeckCardSideboardTableViewCell {
            deckCard?.isSideboard = sideboardCell.sideBoardSwitch.isOn
        }
        CoreDataStack.handler.saveContext()
        if let deckVC = deckViewController {
            deckVC.setUpSections()
            deckVC.tableView.reloadData()
            
        }
        
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 2 {
            return printings.count
        }
        return 1
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionNames[section]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        
        if section == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "quantityCell", for: indexPath) as? DeckCardQuantityTableViewCell {
                cell.quantityLabel.text = "\(deckCard?.quantity ?? 0)"
                cell.quantityStepper.value = Double(deckCard?.quantity ?? 0)
                return cell
            }
        } else if section == 1 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "sideBoardCell", for: indexPath) as? DeckCardSideboardTableViewCell {
                cell.sideBoardSwitch.isOn = deckCard?.isSideboard ?? false
                return cell
            }
            
        } else if section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "printingCell", for: indexPath)
            cell.textLabel?.text = printings[indexPath.row].set.name
            if deckCard?.card?.set.name == printings[indexPath.row].set.name {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
            return cell
        }
        return UITableViewCell()
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for row in 0..<tableView.numberOfRows(inSection: indexPath.section) {
            if let cell = tableView.cellForRow(at: IndexPath(row: row, section: indexPath.section)) {
                cell.accessoryType = row == indexPath.row ? .checkmark : .none
            }
        }
        if indexPath.section == 2 {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            deckCard?.card = printings[indexPath.row]
        }
    }
    
    func getOtherPrintings(){
        if let printingCodes = deckCard?.card?.printings, let name = deckCard?.card?.name {
            let request = NSFetchRequest<Card>(entityName: "Card")
            let sortDescriptor = NSSortDescriptor(key: "set.name", ascending: true)
            request.sortDescriptors = [sortDescriptor]
            
            let setsPredicate = NSPredicate(format: "set.code in %@", printingCodes)
            let namePredicate = NSPredicate(format: "name == %@", name)
            var predicates = [ namePredicate, setsPredicate]
            if UserDefaultsHandler.areOnlineOnlyCardsExcluded() {
                let onlineOnlyPredicate = NSPredicate(format: "set.isOnlineOnly == false")
                predicates.append(onlineOnlyPredicate)
            }
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
            do {
                let results = try CoreDataStack.handler.managedObjectContext.fetch(request)
                printings = results
                self.tableView.reloadData()
            } catch {
                print(error)
            }
        }
    }
}