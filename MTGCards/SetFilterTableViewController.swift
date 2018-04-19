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
    var filterController: FilterTableViewController? = nil
    
    var sets: [String] = []
    var selectedSets: [String] = []
    
    var appDelegate: AppDelegate = (UIApplication.shared.delegate as? AppDelegate)!
    fileprivate let coreDataManager = CoreDataManager(modelName: "MTGCards")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.getSets()
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    func getSets(){
        let fetchRequest: NSFetchRequest<CDMTGSet> = CDMTGSet.fetchRequest()
        let managedContext = appDelegate.persistentContainer.viewContext
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        //fetchRequest.predicate = NSPredicate(format: "name contains[c] %@", searchText)
        do {
            // Perform Fetch Request
            let c = try managedContext.fetch(fetchRequest)
            //print(c.count)
            sets = Array(Set(c.map({$0.name!}))).sorted()
            tableView.reloadData()
        } catch {
            print("Unable to Fetch Cards, (\(error))")
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sets.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "setCell", for: indexPath)
        if let checked = filterController?.cardListView?.filters.sets.contains(sets[indexPath.row]){
            if checked {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
        }
        // Configure the cell...
        cell.textLabel?.text = sets[indexPath.row]
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        let set = sets[indexPath.row]
        selectedSets.append(set)
        filterController?.cardListView?.filters.sets.append(set)
        filterController?.setLabel.text = filterController?.cardListView?.filters.sets.formattedDescription()
        filterController?.tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
