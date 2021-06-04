//
//  SetFilterTableViewController.swift
//  MTGCards
//
//  Created by Joseph Smith on 4/16/18.
//  Copyright © 2018 Robotic Snail Software. All rights reserved.
//

import UIKit
import CoreData

class SetFilterTableViewController: UITableViewController, UISearchResultsUpdating {
    var filterController: FiltersTableViewController? = nil
    
    var sets: [MTGSet] = []
    var filteredSets: [MTGSet] = []
    var selectedSets: [String] = []
    let searchController = UISearchController(searchResultsController: nil)
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Sets"
        searchController.hidesNavigationBarDuringPresentation = false
        navigationItem.searchController = searchController
        definesPresentationContext = true
        self.navigationItem.hidesSearchBarWhenScrolling = false
        tableView.tableFooterView = UIView()
        DispatchQueue.main.async {
            self.getSets()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        
        if let nav = self.navigationController {
            nav.setToolbarHidden(true, animated: false)
            
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
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
    func filterContentForSearchText(_ searchText: String) {
        filteredSets = sets.filter { (set: MTGSet) -> Bool in
            return (set.name?.lowercased().contains(searchText.lowercased()) ?? true) || (set.code?.lowercased().contains(searchText.lowercased()) ?? true)
        }
        
        tableView.reloadData()
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredSets.count
        }
        
        
        return sets.count
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height: CGFloat = 55.0
        #if targetEnvironment(macCatalyst)
        height = 40.0
        #endif
        return height
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "setCell", for: indexPath)
        let set: MTGSet
        if isFiltering {
            set = filteredSets[indexPath.row]
        } else {
            set = sets[indexPath.row]
        }
        if let code = set.code {
            let checked = Filters.current.isSetSelected(setCode: code)
            if checked {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
            
        }
        cell.textLabel?.text = set.name
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let set: MTGSet
        if isFiltering {
            set = filteredSets[indexPath.row]
        } else {
            set = sets[indexPath.row]
        }
        
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
