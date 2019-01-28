//
//  CardListTableViewController.swift
//  MTGCards
//
//  Created by Joseph Smith on 1/16/19.
//  Copyright © 2019 Robotic Snail Software. All rights reserved.
//

import UIKit
import CoreData

class CardListTableViewController: UITableViewController, UISearchResultsUpdating {

   
    
    var appDelegate: AppDelegate = (UIApplication.shared.delegate as? AppDelegate)!
    var cardlist: [Card] = []
    var filteredCardList : [Card] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        //cardlist = DataManager.getRNA()
        cardlist = getSearchCards()
        
        let search = UISearchController(searchResultsController: nil)
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Search"
        search.searchResultsUpdater = self
        navigationItem.searchController = search
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return filteredCardList.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cardCell", for: indexPath)
        cell.textLabel?.text = filteredCardList[indexPath.row].name
        cell.detailTextLabel?.text = filteredCardList[indexPath.row].set.name
        // Configure the cell...
        
        return cell
    }
    private func getSearchCards() -> [Card]{
        var cardList: [Card] = []
        let fetchRequest: NSFetchRequest<Card> = NSFetchRequest<Card>(entityName: "Card")
        let managedContext = appDelegate.persistentContainer.viewContext
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        //let sortDescriptor2 = NSSortDescriptor(key: "set.name", ascending: true)
//        fetchRequest.sortDescriptors = [sortDescriptor, sortDescriptor2]
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.predicate = nil
        do {
            // Perform Fetch Request
            let c = try managedContext.fetch(fetchRequest)
            print(c.count)
            cardList = c
            filteredCardList = c
            return cardList
        } catch {
            print("Unable to Fetch Cards, (\(error))")
            return cardList
        }
        
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
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let name = filteredCardList[indexPath.row].name
        StateCoordinator.shared.didSelectCard(c: filteredCardList[indexPath.row])
    }
    
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text, text.count > 0 else {
            filteredCardList = cardlist
            return
        }
        
        filteredCardList = cardlist.filter(
            { ($0.name?.contains(text))!
                
        })
        tableView.reloadData()
        return
        
    }
    
}
extension CardListTableViewController {
    static func freshCardList() -> CardListTableViewController {
        let storyboard = UIStoryboard(name: "CardList", bundle: nil)
        guard let filelist = storyboard.instantiateInitialViewController() as? CardListTableViewController else {
            fatalError("Project config error - storyboard doesnt provide a FileListVC")
        }
        return filelist
    }
}
