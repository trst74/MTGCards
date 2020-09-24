//
//  SubTypeFilterTableViewController.swift
//  MTGCards
//
//  Created by Joseph Smith on 4/5/18.
//  Copyright © 2018 Robotic Snail Software. All rights reserved.
//

import UIKit
import CoreData

class SubTypeFilterTableViewController: UITableViewController {
    var filterController: FiltersTableViewController? = nil
    
    var types: [String] = []
    var selectedTypes: [String] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        DispatchQueue.main.async {
            self.getTypes()
        }
    }
    func getTypes(){
        let request = NSFetchRequest<CardSubtype>(entityName: "CardSubtype")
        let sortDescriptor = NSSortDescriptor(key: "subtype", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        //request.predicate = NSPredicate(format: "NOT (card.name CONTAINS %@)", "B.F.M.")
        do {
            let results = try CoreDataStack.handler.managedObjectContext.fetch(request)
            types = Array(Set(results.map { $0.subtype ?? "" })).sorted()
            self.tableView.reloadData()
        } catch {
            print(error)
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height: CGFloat = 55.0
        #if targetEnvironment(macCatalyst)
        height = 40.0
        #endif
        return height
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return types.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "subtypeCell", for: indexPath)
        let checked = Filters.current.isSubTypeSelected(type: types[indexPath.row])
        if checked {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        cell.textLabel?.text = types[indexPath.row]
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let type = types[indexPath.row]
        if Filters.current.isSubTypeSelected(type: type){
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
            Filters.current.deselectSubType(type: type)
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            Filters.current.selectSubType(type: type)
        }
        filterController?.subTypeLabel.text = Filters.current.getSelectedSubtypesDescription()
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
