//
//  LegalityFilterTableViewController.swift
//  MTGCards
//
//  Created by Joseph Smith on 4/5/18.
//  Copyright © 2018 Robotic Snail Software. All rights reserved.
//

import UIKit
import CoreData

class LegalityFilterTableViewController: UITableViewController {
    var filterController: FiltersTableViewController? = nil
    
    var legalities: [String] = ["Brawl","Commander","Duel","Frontier","Legacy","Modern","Pauper","Penny", "Standard", "Vintage"]
    var selectedLegalities: [String] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return legalities.count
    }
    
    
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "legalityCell", for: indexPath)
        let checked = Filters.current.isLegalitySelected(legality: legalities[indexPath.row])
        if checked {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        cell.textLabel?.text = legalities[indexPath.row]
        return cell
     }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let legality = legalities[indexPath.row]
        if Filters.current.isLegalitySelected(legality: legality){
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
            Filters.current.deselectLegality(legality: legality)
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            Filters.current.selectLegality(legality: legality)
        }
        filterController?.legalityLabel.text = Filters.current.getSelectedLegalitiesDescription()
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
