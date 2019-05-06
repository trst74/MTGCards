//
//  CardListTableViewController.swift
//  MTGCards
//
//  Created by Joseph Smith on 1/16/19.
//  Copyright © 2019 Robotic Snail Software. All rights reserved.
//

import UIKit
import CoreData
import MobileCoreServices

class CardListTableViewController: UITableViewController, UISearchResultsUpdating, NSFetchedResultsControllerDelegate, UITableViewDragDelegate {
    var fetchedResultsController: NSFetchedResultsController<Card>!
    var cardlist: [Card] = []
    var filteredCardList: [Card] = []
    
    var predicate: NSPredicate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.keyboardDismissMode = .onDrag
        loadSavedData()
        
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationItem.largeTitleDisplayMode = .never
        
        if navigationItem.searchController == nil {
            let search = UISearchController(searchResultsController: nil)
            search.obscuresBackgroundDuringPresentation = false
            search.searchBar.placeholder = "Search"
            search.searchResultsUpdater = self
            search.hidesNavigationBarDuringPresentation = false
            navigationItem.searchController = search
           self.navigationItem.hidesSearchBarWhenScrolling = false
        }
        
        
        tableView.dragDelegate = self
        tableView.dragInteractionEnabled = true
        
        let filterButton = UIBarButtonItem(image: UIImage(named: "filter"), style: .plain, target: self, action: #selector(self.filter))
        self.navigationItem.setRightBarButton(filterButton, animated: true)
    }
    
    @objc func filter(){
        let storyboard = UIStoryboard(name: "Filters", bundle: nil)
        guard let filtersVC = storyboard.instantiateInitialViewController() as? FiltersTableViewController else {
            fatalError("Error going to settings")
        }
        filtersVC.searchTableViewController = self
        self.navigationController?.pushViewController(filtersVC, animated: true)
    }
    func loadSavedData() {
        var filterPredicates = Filters.current.getPredicates()
        if let predicate = predicate {
            filterPredicates.append(predicate)
        }
        let compountPredicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: filterPredicates)
        if fetchedResultsController == nil {
            let request = createFetchRequest()
            
            let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
            let sortDescriptor2 = NSSortDescriptor(key: "set.name", ascending: true)
            request.sortDescriptors = [sortDescriptor, sortDescriptor2]
            //request.sortDescriptors = [sortDescriptor]
            
            
            request.predicate = compountPredicate
            request.fetchBatchSize = 30
            
            fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataStack.handler.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
            fetchedResultsController.delegate = self
        }
        
        fetchedResultsController.fetchRequest.predicate = compountPredicate
        DispatchQueue.main.async {
            do {
                let methodStart = Date()
                try self.fetchedResultsController.performFetch()
                
                let methodFinish = Date()
                let executionTime = methodFinish.timeIntervalSince(methodStart)
                print("Execution time: \(executionTime)")
                self.tableView.reloadData()
                if self.tableView.numberOfSections > 0 && self.tableView.numberOfRows(inSection: 0) > 0 {
                    self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                }
                self.title = "Search (\(self.fetchedResultsController.sections![0].numberOfObjects))"
                
                
            } catch {
                print("Fetch failed")
            }
        }
    }
    func updateTitle(){
        self.title = "Search (\(fetchedResultsController.sections![0].numberOfObjects))"
    }
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let card = fetchedResultsController.object(at: indexPath)
        
        guard let string = card.uuid, let data = string.data(using: .utf8) else { return [] }
        let itemProvider = NSItemProvider(item: data as NSData, typeIdentifier: kUTTypePlainText as String)
        
        return [UIDragItem(itemProvider: itemProvider)]
    }
    func tableView(_ tableView: UITableView, itemsForAddingTo session: UIDragSession, at indexPath: IndexPath, point: CGPoint) -> [UIDragItem] {
        let card = fetchedResultsController.object(at: indexPath)
        
        guard let string = card.uuid, let data = string.data(using: .utf8) else { return [] }
        let itemProvider = NSItemProvider(item: data as NSData, typeIdentifier: kUTTypePlainText as String)
        
        return [UIDragItem(itemProvider: itemProvider)]
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
        cell.backgroundColor = nil
        if let colorIdentities = card.colorIdentity?.allObjects as? [ColorIdentity] {
            let identities: [String?] = colorIdentities.map ({ $0.color })
            var colors: [UIColor] = []
            if identities.contains("W") {
                colors.append(UIColor.Identity.Plains)
            }
            if identities.contains("U") {
                colors.append(UIColor.Identity.Islands)
            }
            if identities.contains("B") {
                colors.append(UIColor.Identity.Swamps)
            }
            if identities.contains("R") {
                colors.append(UIColor.Identity.Mountains)
            }
            if identities.contains("G") {
                colors.append(UIColor.Identity.Forests)
            }
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
    
    func gradient(frame: CGRect, with colors: [CGColor]) -> CAGradientLayer {
        let layer = CAGradientLayer()
        layer.frame = frame
        layer.startPoint = CGPoint(x: 0, y: 0.5)
        layer.endPoint = CGPoint(x: 1, y: 0.5)
        layer.colors = colors
        return layer
    }
    private func createFetchRequest() -> NSFetchRequest<Card> {
        let fetchRequest: NSFetchRequest<Card> = NSFetchRequest<Card>(entityName: "Card")
        
        return fetchRequest
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        StateCoordinator.shared.didSelectCard(id: fetchedResultsController.object(at: indexPath).objectID)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text, text.count > 0 else {
            predicate = nil
            loadSavedData()
            return
        }
        if text.count > 2 {
            predicate = NSPredicate(format: "name contains[c] %@", text)
            loadSavedData()
        }
        return
        
    }
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            print("shaken")
            let total = fetchedResultsController.sections![0].numberOfObjects
            let random = Int.random(in: 0 ..< total)
            
            let card = fetchedResultsController.object(at: IndexPath(item: random, section: 0))
            StateCoordinator.shared.didSelectCard(id: card.objectID)
        }
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
