//
//  SetFilterTableViewController.swift
//  MTGCards
//
//  Created by Joseph Smith on 4/16/18.
//  Copyright © 2018 Robotic Snail Software. All rights reserved.
//

import UIKit
import CoreData

class SetFilterTableViewController: UITableViewController {
    var filterController: FiltersTableViewController? = nil
    
    var sets: [MTGSet] = []
    var selectedSets: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.getSets()
        }
    }
    func getSets(){
        let request = NSFetchRequest<MTGSet>(entityName: "MTGSet")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        let cardCountPredicate = NSPredicate(format: "cards.@count > 0")
        var predicates = [cardCountPredicate]
        if UserDefaultsHandler.areOnlineOnlyCardsExcluded() {
            let onlineOnlyPredicate = NSPredicate(format: "isOnlineOnly == false")
            predicates.append(onlineOnlyPredicate)
        }
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        do {
            let results = try CoreDataStack.handler.managedObjectContext.fetch(request)
            sets = results
            self.tableView.reloadData()
        } catch {
            print(error)
        }
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sets.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "setCell", for: indexPath)
        if let code = sets[indexPath.row].code {
            let checked = Filters.current.isSetSelected(setCode: code)
            if checked {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
            
        }
        cell.textLabel?.text = sets[indexPath.row].name
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let set = sets[indexPath.row]
        if let code = set.code {
            if Filters.current.isSetSelected(setCode: code) {
                tableView.cellForRow(at: indexPath)?.accessoryType = .none
                Filters.current.deselectSet(setCode: code)
            } else {
                tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
                Filters.current.selectSet(setCode: code)
            }
            filterController?.setLabel.text = Filters.current.getSelectedSetsDescription()
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
}
