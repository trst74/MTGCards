//
//  TypeFilterTableViewController.swift
//  MTGCards
//
//  Created by Joseph Smith on 4/3/18.
//  Copyright © 2018 Robotic Snail Software. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class TypeFilterTableViewController: UITableViewController {
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
        let request = NSFetchRequest<CardType>(entityName: "CardType")
        let sortDescriptor = NSSortDescriptor(key: "type", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        request.predicate = NSPredicate(format: "NOT (card.name CONTAINS %@)", "B.F.M.")
        do {
            let results = try CoreDataStack.handler.managedObjectContext.fetch(request)
            types = Array(Set(results.map { $0.type ?? "" })).sorted()
            self.tableView.reloadData()
        } catch {
            print(error)
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return types.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "typeCell", for: indexPath)
        let checked = Filters.current.isTypeSelected(type: types[indexPath.row])
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
        if Filters.current.isTypeSelected(type: type){
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
            Filters.current.deselectType(type: type)
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            Filters.current.selectType(type: type)
        }
        filterController?.typeLabel.text = Filters.current.getSelectedTypesDescription()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
}
