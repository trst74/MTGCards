//
//  FilterViewController.swift
//  MTGCards
//
//  Created by Joseph Smith on 3/21/18.
//  Copyright © 2018 Robotic Snail Software. All rights reserved.
//

import UIKit
import CoreData

class FilterViewController: UIViewController {
    var cardListView: CardsTableViewController? = nil
    
    var appDelegate: AppDelegate = (UIApplication.shared.delegate as? AppDelegate)!
    fileprivate let coreDataManager = CoreDataManager(modelName: "MTGCards")
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func whiteButtonClicked(_ sender: UIButton) {
        if !sender.isSelected{
            cardListView?.filters.colorIdentities.insert("W")
            sender.isSelected = true
        } else {
            cardListView?.filters.colorIdentities.remove("W")
            sender.isSelected = false
        }
    }
    @IBAction func blueButtonClicked(_ sender: UIButton) {
        if !sender.isSelected{
            cardListView?.filters.colorIdentities.insert("U")
            sender.isSelected = true
        } else {
            cardListView?.filters.colorIdentities.remove("U")
            sender.isSelected = false
        }
    }
    @IBAction func blackButtonClicked(_ sender: UIButton) {
        if !sender.isSelected{
            cardListView?.filters.colorIdentities.insert("B")
            sender.isSelected = true
        } else {
            cardListView?.filters.colorIdentities.remove("B")
            sender.isSelected = false
        }
    }
    @IBAction func redButtonClicked(_ sender: UIButton) {
        if !sender.isSelected{
            cardListView?.filters.colorIdentities.insert("R")
            sender.isSelected = true
        } else {
            cardListView?.filters.colorIdentities.remove("R")
            sender.isSelected = false
        }
    }
    @IBAction func greenButtonClicked(_ sender: UIButton) {
        if !sender.isSelected{
            cardListView?.filters.colorIdentities.insert("G")
            sender.isSelected = true
        } else {
            cardListView?.filters.colorIdentities.remove("G")
            sender.isSelected = false
        }
    }
    @IBAction func resetFilters(_ sender: Any) {
        let filter = Filters()
        if let name = cardListView?.filters.name {
            filter.name = name
        }
        cardListView?.filters = filter
    }
    @IBAction func ApplyFilters(_ sender: Any) {
        //applyfilters
        var predicates: [NSPredicate] = []
        
        //name from previous screen
        if let searchText = cardListView?.searchBar.text {
            if searchText != "" {
                let namePredicate = NSPredicate(format: "name contains[c] %@", searchText)
                predicates.append(namePredicate)
            }
        }
        //color identities
        let colorIdentitisPredicate = NSPredicate(format: "ANY colorIdentity.colorIdentity  in %@", (cardListView?.filters.colorIdentities)!)
        predicates.append(colorIdentitisPredicate)
        let filtered = search(predicates: predicates)
        
        cardListView?.cardList = filtered
        DispatchQueue.main.async {
            self.cardListView?.tableView.reloadData()
            let index = IndexPath(row: 0, section: 0)
            self.cardListView?.tableView.scrollToRow(at: index, at: .top, animated: true)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func search(predicates: [NSPredicate]) -> [CDCard]{
        let compountPredicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: predicates)
        
        
        let fetchRequest: NSFetchRequest<CDCard> = CDCard.fetchRequest()
        let managedContext = appDelegate.persistentContainer.viewContext
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.predicate = compountPredicate
        do {
            // Perform Fetch Request
            let c = try managedContext.fetch(fetchRequest)
            //print(c.count)
            return c
            
        } catch {
            print("Unable to Fetch Cards, (\(error))")
            return []
        }
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
