//
//  CardsTableViewController.swift
//  MTGCards
//
//  Created by Joseph Smith on 3/20/18.
//  Copyright © 2018 Robotic Snail Software. All rights reserved.
//

import UIKit
import CoreData

class CardsTableViewController: UITableViewController, UISearchBarDelegate {
    
    var appDelegate: AppDelegate = (UIApplication.shared.delegate as? AppDelegate)!
    fileprivate let coreDataManager = CoreDataManager(modelName: "MTGCards")
    var cardList:[CDCard] = []
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var filters = Filters()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesSearchBarWhenScrolling = false
        // Uncomment the following line to preserve selection between presentations
        tableView.keyboardDismissMode = .onDrag
        searchBar.delegate = self
        self.title = self.title! + " (\(cardList.count))"
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if let searchText = searchBar.text{
            if searchText != "" && searchText.count >= 3{
                search(searchText: searchText)
            }
            else {
                cardList = []
                tableView.reloadData()
            }
            searchBar.endEditing(true)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filters.name = searchText
        if searchText != "" && searchText.count >= 3{
            
            search(searchText: searchText)
        }
        else {
            cardList = []
            self.title = "Search"
            tableView.reloadData()
        }
        
    }
    
    private func filter(searchText: String){
        cardList = cardList.filter{ ($0.name?.contains(searchText))!}
    }
    private func search(searchText: String){
        let fetchRequest: NSFetchRequest<CDCard> = CDCard.fetchRequest()
        let managedContext = appDelegate.persistentContainer.viewContext
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        let sortDescriptor2 = NSSortDescriptor(key: "set.name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor, sortDescriptor2]
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: filters.GetPredicates())
        do {
            // Perform Fetch Request
            let c = try managedContext.fetch(fetchRequest)
            //print(c.count)
            cardList = c
            self.title = "Search (\(cardList.count))"
            tableView.reloadData()
        } catch {
            print("Unable to Fetch Cards, (\(error))")
        }
    }
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            search(searchText: searchText)
        } else {
            cardList = []
            tableView.reloadData()
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
        return cardList.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "card", for: indexPath) as! CardTableViewCell
        let card = cardList[indexPath.row]
        
        cell.cardName?.text = card.name
        
        cell.cardSet?.text = card.set?.name
                cell.layoutIfNeeded()
        cell.sizeToFit()

        if let layer = cell.gradientLayer {
            cell.layer.sublayers?.first(where: {$0 == layer})?.removeFromSuperlayer()
        }
        
        // Configure the cell...
        if let idents = card.colorIdentity?.allObjects {
            
            var identities = idents.map{$0 as? CDColorIdentity}
            
            if identities.count == 1{
                if identities[0]?.colorIdentity == "U" {
                    cell.backgroundColor = UIColor.Identity.Islands
                }
                if identities[0]?.colorIdentity == "B" {
                    cell.backgroundColor = UIColor.Identity.Swamps
                }
                if identities[0]?.colorIdentity == "G" {
                    cell.backgroundColor = UIColor.Identity.Forests
                }
                if identities[0]?.colorIdentity == "R" {
                    cell.backgroundColor = UIColor.Identity.Mountains
                }
                if identities[0]?.colorIdentity == "W" {
                    cell.backgroundColor = UIColor.Identity.Plains
                }
                
            } else if identities.count > 1 {
                var colors: [CGColor] = []
                if identities.contains(where: {$0?.colorIdentity == "W"}){
                    colors.append(UIColor.Identity.Plains.cgColor)
                }
                if identities.contains(where: {$0?.colorIdentity == "U"}){
                    colors.append(UIColor.Identity.Islands.cgColor)
                }
                if identities.contains(where: {$0?.colorIdentity == "B"}){
                    colors.append(UIColor.Identity.Swamps.cgColor)
                }
                if identities.contains(where: {$0?.colorIdentity == "R"}){
                    colors.append(UIColor.Identity.Mountains.cgColor)
                }
                if identities.contains(where: {$0?.colorIdentity == "G"}){
                    colors.append(UIColor.Identity.Forests.cgColor)
                }
                let l = gradient(frame: cell.bounds, with: colors)
                cell.layer.insertSublayer(l, at: 0)
                cell.gradientLayer = l
                
            } else {
                if card.type == "Land" {
                    cell.backgroundColor = UIColor.Identity.Lands
                    
                } else {
                    cell.backgroundColor = UIColor.Identity.Artifacts
                    
                }
            }
            
        }
        cell.layoutSubviews()
        return cell
    }
    func gradient(frame:CGRect, with colors: [CGColor]) -> CAGradientLayer {
        let layer = CAGradientLayer()
        layer.frame = frame
        layer.startPoint = CGPoint(x: 0, y:0.5)
        layer.endPoint = CGPoint(x: 1, y:0.5)
        //layer.colors = [UIColor(red:0.94, green:0.68, blue:0.58, alpha:1.00).cgColor,UIColor(red:0.65, green:0.82, blue:0.69, alpha:1.00).cgColor]
        layer.colors = colors
        return layer
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
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "cardDetailsSegue" {
            
            
            let nextScene =  segue.destination as! CardDetailsViewController
            
            // Pass the selected object to the new view controller.
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let selectedCard = cardList[indexPath.row]
                //print(selectedCard.colorIdentity)
                nextScene.currentCard = selectedCard
                
            }
        }
        else if segue.identifier == "filterSegue" {
            let destination = segue.destination as! UINavigationController
            let filters = destination.topViewController as! FilterTableViewController
            filters.cardListView = self
        }
    }
    
    
}
