//
//  EditDeckCardTableViewController.swift
//  MTGCards
//
//  Created by Joseph Smith on 4/13/19.
//  Copyright © 2019 Robotic Snail Software. All rights reserved.
//

import UIKit
import CoreData

class EditDeckCardTableViewController: UITableViewController, UITextFieldDelegate {
    let sectionNames = ["Quatity","Foil","Sideboard","Commander", "Set"]
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
            if let q = Int(quantityCell.quantity.text ?? "") {
                deckCard?.quantity = Int16(q)
            }
        }
        if let foilCell = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? DeckCardFoilTableViewCell {
            deckCard?.isFoil = foilCell.isFoil.isOn
        }
        if let sideboardCell = tableView.cellForRow(at: IndexPath(row: 0, section: 2)) as? DeckCardSideboardTableViewCell {
            deckCard?.isSideboard = sideboardCell.sideBoardSwitch.isOn
        }
        if let commanderCell = tableView.cellForRow(at: IndexPath(row: 0, section: 3)) as? DeckCardCommanderTableViewCell {
            deckCard?.isCommander = commanderCell.isCommanderSwitch.isOn
        }
        do {
            try CoreDataStack.handler.privateContext.save()
        } catch {
            print(error)
        }
        
        if let deckVC = deckViewController {
            deckVC.setUpSections()
            deckVC.tableView.reloadData()
            
        }
        
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 4 {
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
               
                cell.quantity.text = Int(deckCard?.quantity ?? 0).description
                return cell
            }
        }
        else if section == 1 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "isFoilCell", for: indexPath) as? DeckCardFoilTableViewCell {
                cell.isFoil.isOn = deckCard?.isFoil ?? false
                
                return cell
            }
        }else if section == 2 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "sideBoardCell", for: indexPath) as? DeckCardSideboardTableViewCell {
                cell.sideBoardSwitch.isOn = deckCard?.isSideboard ?? false
                return cell
            }
            
        } else if section == 3 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "isCommanderCell", for: indexPath) as? DeckCardCommanderTableViewCell {
                cell.isCommanderSwitch.isOn = deckCard?.isCommander ?? false
                return cell
            }
        } else if section == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "printingCell", for: indexPath)
            cell.textLabel?.text = "\(printings[indexPath.row].set.name ?? "") (\(printings[indexPath.row].number ?? ""))"
            if deckCard?.card?.set.name == printings[indexPath.row].set.name && deckCard?.card?.number == printings[indexPath.row].number {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
            return cell
        }
        return UITableViewCell()
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height: CGFloat = 55.0
        #if targetEnvironment(macCatalyst)
        height = 40.0
        #endif
        return height
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 4 {
            for row in 0..<tableView.numberOfRows(inSection: indexPath.section) {
                if let cell = tableView.cellForRow(at: IndexPath(row: row, section: indexPath.section)) {
                    cell.accessoryType = row == indexPath.row ? .checkmark : .none
                }
            }
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            deckCard?.card = printings[indexPath.row]
        }
        tableView.deselectRow(at: indexPath, animated: true)
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
                let results = try CoreDataStack.handler.privateContext.fetch(request)
                printings = results
                self.tableView.reloadData()
            } catch {
                print(error)
            }
        }
    }
}
extension UITextField{
    
    func addDoneButtonToKeyboard(myAction:Selector?){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
        doneToolbar.barStyle = UIBarStyle.default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: myAction)
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
}
