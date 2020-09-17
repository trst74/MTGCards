//
//  CollectionsTableViewController.swift
//  MTGCards
//
//  Created by Joseph Smith on 1/16/19.
//  Copyright © 2019 Robotic Snail Software. All rights reserved.
//

import UIKit
import CoreData
import MobileCoreServices
import UniformTypeIdentifiers

class CollectionsTableViewController: UITableViewController, UITableViewDropDelegate, UIDocumentPickerDelegate  {
    
    var stateCoordinator: StateCoordinator?
    var collections = ["Collections"]
    var cdCollections: [Collection] = []
    var decks = ["Decks"]
    var cdDecks: [Deck] = []
    var search = ["Tools", "Search"]
    var sections: [[String]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !(self.splitViewController?.traitCollection.horizontalSizeClass == .regular) {
            self.title = "Collections"
        }
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "collectionCell")
        self.navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addButton(sender:))), animated: true)
        let settingsButton = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: self, action: #selector(self.settings))
        self.navigationItem.setLeftBarButton(settingsButton, animated: true)
        sections = [ search, collections, decks]
        tableView.dropDelegate = self
        tableView.dragInteractionEnabled = true
        
        if UserDefaultsHandler.isFirstTimeOpening(){
            firstTimeOpened()
        }
        reloadDecksFromCoreData()
        reloadCollectionsFromCoreData()
        tableView.tableFooterView = UIView()
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
    @objc func addButton(sender: UIBarButtonItem) {
        let menuAlert = UIAlertController(title: "Create Deck(s)", message: nil, preferredStyle: .actionSheet)
        menuAlert.addAction(UIAlertAction(title: "New Empty Deck", style: .default, handler: {action in  self.addBlankDeck()}))
        let pasteboard = UIPasteboard.general
        if pasteboard.string != nil {
            menuAlert.addAction(UIAlertAction(title: "New Deck from Clipboard", style: .default, handler: {action in  self.addDeckFromClipboard()}))
        }
        menuAlert.addAction(UIAlertAction(title: "New Deck(s) from File(s)", style: .default, handler: {action in  self.addDecksFromFiles()}))
        menuAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        menuAlert.popoverPresentationController?.barButtonItem = sender
        self.present(menuAlert, animated: true)
    }
    func addBlankDeck(){
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
                    self.reloadCollectionsFromCoreData()
                    self.tableView.reloadData()
                }
            }
        }))
        self.present(alert, animated: true)
    }
    func addDeckFromClipboard() {
        let alert = UIAlertController(title: "Deck Name?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Deck Name"
            textField.autocapitalizationType = .words
        })
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { action in
            if let name = alert.textFields?.first?.text {
                guard  let entity = NSEntityDescription.entity(forEntityName: "Deck", in:  CoreDataStack.handler.privateContext) else {
                    fatalError("Failed to decode Card")
                }
                let newDeck = Deck.init(entity: entity, insertInto: CoreDataStack.handler.privateContext)
                newDeck.name = name
                //get clipboard
                let pasteboard = UIPasteboard.general
                if let string = pasteboard.string {
                    let lines = string.components(separatedBy: CharacterSet.newlines)
                    print(lines.count)
                    var previousline = ""
                    var isSideboard = false
                    for line in lines {
                        if line != "" {
                            var parts = line.split(separator: " ")
                            let quantity = parts[0]
                            parts.remove(at: 0)
                            var name = ""
                            var setCode = ""
                            for p in parts {
                                if p.contains("(") {
                                    setCode = String(p)
                                    break
                                } else {
                                    name += " "+p
                                }
                            }
                            while let range = setCode.range(of: "(") {
                                setCode.removeSubrange(range.lowerBound..<range.upperBound)
                            }
                            while let range = setCode.range(of: ")") {
                                setCode.removeSubrange(range.lowerBound..<range.upperBound)
                            }
                            print("test")
                            self.addCard(name: name, setCode: setCode, quantity: Int(quantity) ?? 1, isSideboard: isSideboard, newDeck: newDeck)
                        } else if previousline == "" {
                            print("sideboard start")
                            isSideboard = true
                        }
                        previousline = line
                    }
                }
                do {
                    try CoreDataStack.handler.privateContext.save()
                } catch {
                    print(error)
                }
                self.reloadDecksFromCoreData()
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }))
        self.present(alert, animated: true)
    }
    func addDecksFromFiles(){
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.text])
        documentPicker.allowsMultipleSelection = true
        documentPicker.delegate = self
        self.present(documentPicker, animated: true)
    }
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        print(urls)
        for url in urls {
            importFile(url: url)
        }
    }
    private func importFile(url: URL){
        do {
            guard  let entity = NSEntityDescription.entity(forEntityName: "Deck", in:  CoreDataStack.handler.privateContext) else {
                fatalError("Failed to decode Card")
            }
            let newDeck = Deck.init(entity: entity, insertInto: CoreDataStack.handler.privateContext)
            let name = url.absoluteURL.deletingPathExtension().lastPathComponent
            newDeck.name = name
            let contents = try String.init(contentsOf: url)
            let lines = contents.components(separatedBy: CharacterSet.newlines)
            print(lines.count)
            var previousline = ""
            var isSideboard = false
            for line in lines {
                if line != "" {
                    var parts = line.split(separator: " ")
                    let quantity = parts[0]
                    parts.remove(at: 0)
                    var name = ""
                    var setCode = ""
                    for p in parts {
                        if p.contains("(") {
                            setCode = String(p)
                            break
                        } else {
                            name += " "+p
                        }
                    }
                    while let range = setCode.range(of: "(") {
                        setCode.removeSubrange(range.lowerBound..<range.upperBound)
                    }
                    while let range = setCode.range(of: ")") {
                        setCode.removeSubrange(range.lowerBound..<range.upperBound)
                    }
                    print("test")
                    addCard(name: name, setCode: setCode, quantity: Int(quantity) ?? 1, isSideboard: isSideboard, newDeck: newDeck)
                } else if previousline == "" {
                    print("sideboard start")
                    isSideboard = true
                }
                previousline = line
            }
            do {
                try CoreDataStack.handler.privateContext.save()
            } catch {
                print(error)
            }
            self.reloadDecksFromCoreData()
            self.reloadCollectionsFromCoreData()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            print(error)
        }
        
    }
    private func addCard(name: String, setCode: String, quantity: Int, isSideboard: Bool, newDeck: Deck){
        let card = getCard(name: name, setCode: setCode)
        if let card = card {
            guard  let entity = NSEntityDescription.entity(forEntityName: "DeckCard", in:  CoreDataStack.handler.privateContext) else {
                fatalError("Failed to decode Card")
            }
            let deckCard = DeckCard.init(entity: entity, insertInto: CoreDataStack.handler.privateContext)
            deckCard.card = card
            deckCard.quantity = Int16(quantity)
            deckCard.isSideboard = isSideboard
            newDeck.addToCards(deckCard)
        }
    }
    private func getCard(name: String, setCode: String) -> Card? {
        var card: Card?
        let request = NSFetchRequest<Card>(entityName: "Card")
        let predicate1 = NSPredicate(format: "name == %@", name.trimmingCharacters(in: CharacterSet.whitespaces))
        let predicate2 = NSPredicate(format: "set.code == %@", setCode)
        var predicates = [predicate1]
        
        if setCode != "" {
            predicates.append(predicate2)
        } else {
            predicates.append(NSPredicate(format: "set.type != %@", "promo"))
        }
        if UserDefaultsHandler.areOnlineOnlyCardsExcluded() {
            let onlineOnlyPredicate = NSPredicate(format: "set.isOnlineOnly == false")
            predicates.append(onlineOnlyPredicate)
        }
        
        let compound = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        request.predicate = compound
        let sortDescriptor = NSSortDescriptor(key: "set.releaseDate", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        do {
            let results = try CoreDataStack.handler.privateContext.fetch(request)
            if results.count > 0 {
                card = results[0]
            }
        } catch {
            print(error)
            card = nil
        }
        return card
    }
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        if let indexPath = coordinator.destinationIndexPath {
            if indexPath.section == 2 {
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
                                guard  let entity = NSEntityDescription.entity(forEntityName: "DeckCard", in:  CoreDataStack.handler.privateContext) else {
                                    fatalError("Failed to decode Card")
                                }
                                let deckCard = DeckCard.init(entity: entity, insertInto: CoreDataStack.handler.privateContext)
                                deckCard.card = card
                                deckCard.quantity = 1
                                self.cdDecks[indexPath.row].addToCards(deckCard)
                                do {
                                    try CoreDataStack.handler.privateContext.save()
                                } catch {
                                    print(error)
                                }
                            }
                        }
                    }
                }
            } else if indexPath.section == 1 {
                coordinator.session.loadObjects(ofClass: NSString.self) { items in
                    guard let strings = items as? [String] else { return }
                    for string in strings {
                        print(string)
                        let card = self.getCard(byUUID: string)
                        
                        if let card = card {
                            guard  let entity = NSEntityDescription.entity(forEntityName: "CollectionCard", in:  CoreDataStack.handler.privateContext) else {
                                fatalError("Failed to decode Card")
                            }
                            let collectionCard = CollectionCard.init(entity: entity, insertInto: CoreDataStack.handler.privateContext)
                            collectionCard.card = card
                            collectionCard.quantity = 1
                            self.cdCollections[indexPath.row].addToCards(collectionCard)
                            do {
                                try CoreDataStack.handler.privateContext.save()
                            } catch {
                                print(error)
                            }
                            
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
        if section == 2 {
            return cdDecks.count
        } else if section == 1 {
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
        if indexPath.section == 1 {
            cell.textLabel?.text = cdCollections[indexPath.row].name
        } else if indexPath.section == 2 {
            cell.textLabel?.text = cdDecks[indexPath.row].name
        } else {
            cell.textLabel?.text = sections[indexPath.section][indexPath.row + 1]
        }
        // Configure the cell...
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        if indexPath.section == 0 {
        //            //StateCoordinator.shared.didSelectCollection(collection: "Search")
        //            StateCoordinator.shared.didSelectTool(tool: "Search")
        //        } else if indexPath.section == 2 {
        //            StateCoordinator.shared.didSelectDeck(d: cdDecks[indexPath.row].objectID)
        //        } else if indexPath.section == 1 {
        //            StateCoordinator.shared.didSelectCollection(collection: cdCollections[indexPath.row].objectID)
        //        }
        //
        if !(self.splitViewController?.traitCollection.horizontalSizeClass == .regular) {
            if indexPath.section == 0 {
                //StateCoordinator.shared.didSelectCollection(collection: "Search")
                self.navigationController?.pushViewController(CardListTableViewController.freshCardList(), animated: true)
            } else if indexPath.section == 2 {
                //StateCoordinator.shared.didSelectDeck(d: cdDecks[indexPath.row].objectID)
                self.navigationController?.pushViewController(DeckTableViewController.freshDeck(deck: cdDecks[indexPath.row].objectID), animated: true)
            } else if indexPath.section == 1 {
                //StateCoordinator.shared.didSelectCollection(collection: cdCollections[indexPath.row].objectID)
                self.navigationController?.pushViewController(CollectionTableViewController.freshCollection(collection: cdCollections[indexPath.row].objectID), animated: true)
            }
            //self.navigationController?.pushViewController(details, animated: true)
        } else {
            
            if indexPath.section == 0 {
                //StateCoordinator.shared.didSelectCollection(collection: "Search")
                self.splitViewController?.setViewController(nil, for: .supplementary)
                self.splitViewController?.setViewController(CardListTableViewController.freshCardList(), for: .supplementary)
            } else if indexPath.section == 2 {
                //StateCoordinator.shared.didSelectDeck(d: cdDecks[indexPath.row].objectID)
                self.splitViewController?.setViewController(nil, for: .supplementary)
                self.splitViewController?.setViewController(DeckTableViewController.freshDeck(deck: cdDecks[indexPath.row].objectID), for: .supplementary)
                
                self.splitViewController?.setViewController(nil, for: .secondary)
                self.splitViewController?.setViewController(DeckStatsTableViewController.refreshDeckStats(id: cdDecks[indexPath.row].objectID), for: .secondary)
                
            } else if indexPath.section == 1 {
                //StateCoordinator.shared.didSelectCollection(collection: cdCollections[indexPath.row].objectID)
                self.splitViewController?.setViewController(nil, for: .supplementary)
                self.splitViewController?.setViewController(CollectionTableViewController.freshCollection(collection: cdCollections[indexPath.row].objectID), for: .supplementary)
            }
        }
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height: CGFloat = 40
        #if targetEnvironment(macCatalyst)
        height = 20
        #endif
        return height
    }
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if indexPath.section == 2 {
            
            
            let editAction = UIContextualAction(style: .normal, title: "Edit") {
                (contextaction: UIContextualAction, sourceView: UIView, completionHandler: (Bool) -> Void) in
                
                let deck = self.cdDecks[indexPath.row]
                let storyboard = UIStoryboard(name: "EditDeck", bundle: nil)
                guard let editDeckView = storyboard.instantiateInitialViewController() as? EditDeckTableViewController else {
                    fatalError("Project config error - storyboard doesnt provide a EditDeckCard")
                }
                editDeckView.deck = deck
                editDeckView.collectionsViewController = self
                self.present(editDeckView, animated: true, completion: nil)
                completionHandler(true)
            }
            editAction.backgroundColor = .gray
            return UISwipeActionsConfiguration(actions: [editAction])
        }
        return nil
    }
    override func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let edit = UIAction(title: "Edit",
                            image: UIImage(systemName: "pencil")) { _ in
            let deck = self.cdDecks[indexPath.row]
            let storyboard = UIStoryboard(name: "EditDeck", bundle: nil)
            guard let editDeckView = storyboard.instantiateInitialViewController() as? EditDeckTableViewController else {
                fatalError("Project config error - storyboard doesnt provide a EditDeckCard")
            }
            editDeckView.deck = deck
            editDeckView.collectionsViewController = self
            self.present(editDeckView, animated: true, completion: nil)
            
        }
        
        
        let delete = UIAction(title: "Delete",
                              image: UIImage(systemName: "trash.fill"),
                              attributes: [.destructive]) { action in
            CoreDataStack.handler.privateContext.delete(self.cdDecks[indexPath.row] as NSManagedObject)
            do {
                try CoreDataStack.handler.privateContext.save()
            } catch {
                print(error)
            }
            self.reloadDecksFromCoreData()
            DispatchQueue.main.async {
                
                self.tableView.reloadData()
            }
        }
        
        return UIContextMenuConfiguration(identifier: nil,
                                          previewProvider: nil) { _ in
            UIMenu(title: "", children: [edit, delete])
        }
    }
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 2 {
            return true
        }
        return false
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("delete")
            CoreDataStack.handler.privateContext.delete(cdDecks[indexPath.row] as NSManagedObject)
            do {
                try CoreDataStack.handler.privateContext.save()
            } catch {
                print(error)
            }
            self.reloadDecksFromCoreData()
            DispatchQueue.main.async {
                
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
