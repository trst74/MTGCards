//
//  SuperTypeFilterTableViewController.swift
//  MTGCards
//
//  Created by Joseph Smith on 4/5/18.
//  Copyright © 2018 Robotic Snail Software. All rights reserved.
//

import UIKit
import CoreData

class SuperTypeFilterTableViewController: UITableViewController {
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
    override func viewWillAppear(_ animated: Bool) {
        
        if let nav = self.navigationController {
            nav.setToolbarHidden(true, animated: false)
            
        }
    }
    func getTypes(){
        let request = NSFetchRequest<CardSupertype>(entityName: "CardSupertype")
        let sortDescriptor = NSSortDescriptor(key: "supertype", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        //request.predicate = NSPredicate(format: "NOT (card.name CONTAINS %@)", "B.F.M.")
        do {
            let results = try CoreDataStack.handler.managedObjectContext.fetch(request)
            types = Array(Set(results.map { $0.supertype ?? "" })).sorted()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "supertypeCell", for: indexPath)
        let checked = Filters.current.isSuperTypeSelected(type: types[indexPath.row])
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
        if Filters.current.isSuperTypeSelected(type: type){
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
            Filters.current.deselectSuperType(type: type)
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            Filters.current.selectSuperType(type: type)
        }
        filterController?.superTypeLabel.text = Filters.current.getSelectedSuperTypesDescription()
        tableView.deselectRow(at: indexPath, animated: true)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
