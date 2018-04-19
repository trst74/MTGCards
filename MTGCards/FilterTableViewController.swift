//
//  FilterTableViewController.swift
//  MTGCards
//
//  Created by Joseph Smith on 4/3/18.
//  Copyright © 2018 Robotic Snail Software. All rights reserved.
//

import UIKit
import CoreData

class FilterTableViewController: UITableViewController {
    
    var cardListView: CardsTableViewController? = nil
    
    var appDelegate: AppDelegate = (UIApplication.shared.delegate as? AppDelegate)!
    fileprivate let coreDataManager = CoreDataManager(modelName: "MTGCards")
    
    @IBOutlet weak var typesLabel: UILabel!
    @IBOutlet weak var legalitiesLabel: UILabel!
    @IBOutlet weak var subtypeLabel: UILabel!
    @IBOutlet weak var supertypeLabel: UILabel!
    @IBOutlet weak var setLabel: UILabel!
    
    @IBOutlet weak var whiteButton: UIButton!
    @IBOutlet weak var blueButton: UIButton!
    @IBOutlet weak var blackButton: UIButton!
    @IBOutlet weak var redButton: UIButton!
    @IBOutlet weak var greenButton: UIButton!
    @IBOutlet weak var colorlessButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (cardListView?.filters.colorIdentities.contains("W"))!{
            whiteButton.isSelected = true
        }
        if (cardListView?.filters.colorIdentities.contains("U"))!{
            blueButton.isSelected = true
        }
        if (cardListView?.filters.colorIdentities.contains("B"))!{
            blackButton.isSelected = true
        }
        if (cardListView?.filters.colorIdentities.contains("R"))!{
            redButton.isSelected = true
        }
        if (cardListView?.filters.colorIdentities.contains("G"))!{
            greenButton.isSelected = true
              greenButton.setImage(UIImage(named: "G8.png"), for: .normal)
        }
        if (cardListView?.filters.colorIdentities.contains("C"))!{
            colorlessButton.isSelected = true
        }
        
        if let count = cardListView?.filters.types.count {
            if count > 0 {
                typesLabel.text = cardListView?.filters.types.formattedDescription()
            }
        }
        if let count = cardListView?.filters.superTypes.count {
            if count > 0 {
                supertypeLabel.text = cardListView?.filters.superTypes.formattedDescription()
            }
        }
        if let count = cardListView?.filters.subTypes.count {
            if count > 0 {
                subtypeLabel.text = cardListView?.filters.subTypes.formattedDescription()
            }
        }
        if let count = cardListView?.filters.legalities.count {
            if count > 0 {
                legalitiesLabel.text = cardListView?.filters.legalities.formattedDescription()
            }
        }
        if let count = cardListView?.filters.sets.count {
            if count > 0 {
                setLabel.text = cardListView?.filters.sets.formattedDescription()
            }
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        
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
            sender.setImage(UIImage(named: "G8.png"), for: .normal)
            sender.isSelected = true
        } else {
            cardListView?.filters.colorIdentities.remove("G")
            sender.setImage(UIImage(named: "G8-Light.png"), for: .normal)
            sender.isSelected = false
        }
    }
    @IBAction func colorlessButtonClicked(_ sender: UIButton) {
        if !sender.isSelected{
            cardListView?.filters.colorIdentities.insert("C")
            sender.isSelected = true
        } else {
            cardListView?.filters.colorIdentities.remove("C")
            sender.isSelected = false
        }
    }
    @IBAction func resetFilters(_ sender: Any) {
        let filter = Filters()
        if let name = cardListView?.filters.name {
            filter.name = name
        }
        cardListView?.filters = filter
        typesLabel.text = "All"
        subtypeLabel.text = "All"
        supertypeLabel.text = "All"
        legalitiesLabel.text = "All"
        setLabel.text = "All"
    }
    
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func ApplyFilters(_ sender: Any) {
        //applyfilters
        if let predicates = cardListView?.filters.GetPredicates() {
            
            let filtered = search(predicates: predicates)
            cardListView?.cardList = filtered
            DispatchQueue.main.async {
                self.cardListView?.tableView.reloadData()
                let index = IndexPath(row: 0, section: 0)
                if let count = self.cardListView?.cardList.count {
                    self.cardListView?.title = "Search (\(count))"
                }
                if let count =  self.cardListView?.cardList.count {
                    if count > 0 {
                        self.cardListView?.tableView.scrollToRow(at: index, at: .top, animated: true)
                    }
                }
            }
        }
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "typesFilter" {
            let destination = segue.destination as! TypeFilterTableViewController
            destination.filterController = self
            destination.title = "Types"
        } else if segue.identifier == "legalityFilter" {
            let destination = segue.destination as! LegalityFilterTableViewController
            destination.filterController = self
            destination.title = "Legalities"
        } else if segue.identifier == "subtypeFilter" {
            let destination = segue.destination as! SubTypeFilterTableViewController
            destination.filterController = self
            destination.title = "Sub Type"
        } else if segue.identifier == "supertypeFilter" {
            let destination = segue.destination as! SuperTypeFilterTableViewController
            destination.filterController = self
            destination.title = "Super Type"
        } else if segue.identifier == "setsFilter" {
            let destination = segue.destination as! SetFilterTableViewController
            destination.filterController = self
            destination.title = "Set"
        }
        
    }
    
}
