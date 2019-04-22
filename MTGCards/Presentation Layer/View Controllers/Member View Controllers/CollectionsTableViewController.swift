//
//  CollectionsTableViewController.swift
//  MTGCards
//
//  Created by Joseph Smith on 1/16/19.
//  Copyright © 2019 Robotic Snail Software. All rights reserved.
//

import UIKit
import CoreData

class CollectionsTableViewController: UITableViewController, UITableViewDropDelegate {
    
    var stateCoordinator: StateCoordinator?
    var collections = ["Collections"]
    var cdCollections: [Collection] = []
    var decks = ["Decks"]
    var cdDecks: [Deck] = []
    var search = ["Tools", "Search", "Life Counter", "Rules"]
    var sections: [[String]] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addButton)), animated: true)
        let settingsButton = UIBarButtonItem(image: UIImage(named: "settings"), style: .plain, target: self, action: #selector(self.settings))
        self.navigationItem.setLeftBarButton(settingsButton, animated: true)
        sections = [collections, decks, search]
        tableView.dropDelegate = self
        tableView.dragInteractionEnabled = true
        if UserDefaultsHandler.isFirstTimeOpening(){
            firstTimeOpened()
        }
        reloadDecksFromCoreData()
        reloadCollectionsFromCoreData()
    }
    private func firstTimeOpened(){
        guard  let entity = NSEntityDescription.entity(forEntityName: "Collection", in:  CoreDataStack.handler.managedObjectContext) else {
            fatalError("Failed to decode Card")
        }
        let collection = Collection.init(entity: entity, insertInto: CoreDataStack.handler.managedObjectContext)
        collection.name = "Collection"
        let wishlist = Collection.init(entity: entity, insertInto: CoreDataStack.handler.managedObjectContext)
        wishlist.name = "Wish List"
        CoreDataStack.handler.saveContext()
    }
    @objc func addButton() {
        let alert = UIAlertController(title: "Deck Name?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Deck Name"
            textField.autocapitalizationType = .words
        })
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { action in
            if let name = alert.textFields?.first?.text {
                guard  let entity = NSEntityDescription.entity(forEntityName: "Deck", in:  CoreDataStack.handler.managedObjectContext) else {
                    fatalError("Failed to decode Card")
                }
                let newDeck = Deck.init(entity: entity, insertInto: CoreDataStack.handler.managedObjectContext)
                newDeck.name = name
                CoreDataStack.handler.saveContext()
                self.reloadDecksFromCoreData()
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }))
        self.present(alert, animated: true)
    }
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        if let indexPath = coordinator.destinationIndexPath {
            if indexPath.section == 1 {
                coordinator.session.loadObjects(ofClass: NSString.self) { items in
                    guard let strings = items as? [String] else { return }
                    for string in strings {
                        print(string)
                        let deck = self.cdDecks[indexPath.row]
                        let card = self.getCard(byUUID: string)
                        let results = deck.cards?.filter {
                            if let deckCard = $0 as? DeckCard {
                                return deckCard.card == card
                            }
                            return false
                        }
                        if results?.count ?? 0 > 0 {
                            if let found: DeckCard = results?[0] as? DeckCard {
                                found.quantity += 1
                                CoreDataStack.handler.saveContext()
                            }
                        } else {
                            if let card = card {
                                guard  let entity = NSEntityDescription.entity(forEntityName: "DeckCard", in:  CoreDataStack.handler.managedObjectContext) else {
                                    fatalError("Failed to decode Card")
                                }
                                let deckCard = DeckCard.init(entity: entity, insertInto: CoreDataStack.handler.managedObjectContext)
                                deckCard.card = card
                                deckCard.quantity = 1
                                self.cdDecks[indexPath.row].addToCards(deckCard)
                                CoreDataStack.handler.saveContext()
                            }
                        }
                    }
                }
            } else if indexPath.section == 0 {
                coordinator.session.loadObjects(ofClass: NSString.self) { items in
                    guard let strings = items as? [String] else { return }
                    for string in strings {
                        print(string)
                        let card = self.getCard(byUUID: string)
                        
                        if let card = card {
                            guard  let entity = NSEntityDescription.entity(forEntityName: "CollectionCard", in:  CoreDataStack.handler.managedObjectContext) else {
                                fatalError("Failed to decode Card")
                            }
                            let collectionCard = CollectionCard.init(entity: entity, insertInto: CoreDataStack.handler.managedObjectContext)
                            collectionCard.card = card
                            collectionCard.quantity = 1
                            self.cdCollections[indexPath.row].addToCards(collectionCard)
                            CoreDataStack.handler.saveContext()
                            
                        }
                        //save
                    }
                }
                
            }
        }
    }
    private func getCard(byUUID: String) -> Card? {
        var card: Card?
        let request = NSFetchRequest<Card>(entityName: "Card")
        request.predicate = NSPredicate(format: "uuid == %@", byUUID)
        do {
            let results = try CoreDataStack.handler.privateContext.fetch(request)
            if results.count > 1 {
                print("Too many items with uuid \(byUUID)")
            } else {
                card = results[0]
            }
        } catch {
            print(error)
            card = nil
        }
        return card
    }
    private func reloadDecksFromCoreData(){
        let request = NSFetchRequest<Deck>(entityName: "Deck")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        do {
            let results = try CoreDataStack.handler.privateContext.fetch(request)
            cdDecks = results
        } catch {
            print(error)
        }
    }
    private func reloadCollectionsFromCoreData(){
        let request = NSFetchRequest<Collection>(entityName: "Collection")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        do {
            let results = try CoreDataStack.handler.privateContext.fetch(request)
            cdCollections = results
        } catch {
            print(error)
        }
    }
    @objc func settings(){
        let storyboard = UIStoryboard(name: "Settings", bundle: nil)
        guard let settingsVC = storyboard.instantiateInitialViewController() as? SettingsTableViewController else {
            fatalError("Error going to settings")
        }
        //self.navigationController?.pushViewController(settingsVC, animated: true)
        self.present(settingsVC, animated: true, completion: nil)
    }
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 1 {
            return cdDecks.count
        } else if section == 0 {
            return cdCollections.count
        } else {
            return sections[section].count - 1
        }
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section][0]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "collectionCell", for: indexPath)
        if indexPath.section == 0 {
             cell.textLabel?.text = cdCollections[indexPath.row].name
        } else if indexPath.section == 1 {
            cell.textLabel?.text = cdDecks[indexPath.row].name
        } else {
            cell.textLabel?.text = sections[indexPath.section][indexPath.row + 1]
        }
        // Configure the cell...
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            //StateCoordinator.shared.didSelectCollection(collection: "Search")
            StateCoordinator.shared.didSelectTool(tool: "Search")
        } else if indexPath.section == 1 {
            StateCoordinator.shared.didSelectDeck(d: cdDecks[indexPath.row])
        } else if indexPath.section == 0 {
            StateCoordinator.shared.didSelectCollection(collection: cdCollections[indexPath.row])
        }
    }
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 1 {
            return true
        }
        return false
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("delete")
            CoreDataStack.handler.managedObjectContext.delete(cdDecks[indexPath.row] as NSManagedObject)
            CoreDataStack.handler.saveContext()
            
            DispatchQueue.main.async {
                self.reloadDecksFromCoreData()
                self.tableView.reloadData()
            }
        }
    }
}
extension CollectionsTableViewController {
    static func freshCollectionsList() -> CollectionsTableViewController {
        let storyboard = UIStoryboard(name: "Collections", bundle: nil)
        guard let filelist = storyboard.instantiateInitialViewController() as? CollectionsTableViewController else {
            fatalError("Project config error - storyboard doesnt provide a FileListVC")
        }
        return filelist
    }
}
