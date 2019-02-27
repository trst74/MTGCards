//
//  CardListTableViewController.swift
//  MTGCards
//
//  Created by Joseph Smith on 1/16/19.
//  Copyright © 2019 Robotic Snail Software. All rights reserved.
//

import UIKit
import CoreData

class CardListTableViewController: UITableViewController, UISearchResultsUpdating, NSFetchedResultsControllerDelegate{
    
    var fetchedResultsController: NSFetchedResultsController<Card>!
    
    var appDelegate: AppDelegate = (UIApplication.shared.delegate as? AppDelegate)!
    var cardlist: [Card] = []
    var filteredCardList : [Card] = []
    
    var predicate: NSPredicate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //cardlist = DataManager.getRNA()
        //cardlist = getSearchCards()
        loadSavedData()
        
        let search = UISearchController(searchResultsController: nil)
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Search"
        search.searchResultsUpdater = self
        navigationItem.searchController = search
        
        self.navigationItem.hidesSearchBarWhenScrolling = false
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    func loadSavedData() {
        if fetchedResultsController == nil {
            let request = createFetchRequest()
   
            let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
            let sortDescriptor2 = NSSortDescriptor(key: "set.name", ascending: true)
            request.sortDescriptors = [sortDescriptor, sortDescriptor2]
            request.predicate = predicate
            request.fetchBatchSize = 20
            
            fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: appDelegate.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
            fetchedResultsController.delegate = self
        }
        
        fetchedResultsController.fetchRequest.predicate = predicate
        
        do {
            try fetchedResultsController.performFetch()
            tableView.reloadData()
        } catch {
            print("Fetch failed")
        }
    }
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return fetchedResultsController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return fetchedResultsController.sections![section].numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cardCell", for: indexPath) as! CardListTableViewCell
        let card = fetchedResultsController.object(at: indexPath)
        cell.title?.text = card.name
        cell.subtitle?.text = card.set.name
        // Configure the cell...
        //        if let layer = cell.gradientLayer {
        //            cell.layer.sublayers?.first(where: {$0 == layer})?.removeFromSuperlayer()
        //        }
        cell.backgroundColor = nil
        if let identities = card.colorIdentity {
            
            
            var colors: [UIColor] = []
            
            
            if identities.contains("W"){
                colors.append(UIColor.Identity.Plains)
            }
            if identities.contains("U"){
                colors.append(UIColor.Identity.Islands)
            }
            if identities.contains("B"){
                colors.append(UIColor.Identity.Swamps)
            }
            if identities.contains("R"){
                colors.append(UIColor.Identity.Mountains)
            }
            if identities.contains("G"){
                colors.append(UIColor.Identity.Forests)
            }
            //                let l = gradient(frame: cell.bounds, with: colors)
            //                cell.layer.insertSublayer(l, at: 0)
            //                cell.gradientLayer = l
            
            
            if colors.count == 0 {
                if card.type == "Land" {
                    colors = [UIColor.Identity.Lands]
                    
                } else {
                    colors = [UIColor.Identity.Artifacts]
                    
                }
            }
            if colors.count == 1 {
                colors += colors
            }
            cell.gradientView?.colors = colors
        }
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
    private func createFetchRequest() -> NSFetchRequest<Card>{
        let fetchRequest: NSFetchRequest<Card> = NSFetchRequest<Card>(entityName: "Card")
   
        return fetchRequest
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        StateCoordinator.shared.didSelectCard(c: fetchedResultsController.object(at: indexPath))
    }
    
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text, text.count > 0 else {
//            filteredCardList = cardlist
            predicate = nil
            return
        }
//
//        filteredCardList = cardlist.filter(
//            { ($0.name?.contains(text))!
//
//        })
//        tableView.reloadData()
        
        predicate = NSPredicate(format: "name contains[c] %@", text)
        loadSavedData()
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
