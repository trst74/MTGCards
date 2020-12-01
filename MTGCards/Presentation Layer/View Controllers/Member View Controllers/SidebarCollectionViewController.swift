//
//  SidebarCollectionViewController.swift
//  MTGCards
//
//  Created by Joseph Smith on 10/19/20.
//  Copyright © 2020 Robotic Snail Software. All rights reserved.
//

import UIKit
import CoreData
import MobileCoreServices
import UniformTypeIdentifiers
//#if !targetEnvironment(macCatalyst)
//@objc protocol NSToolbarDelegate {
//}
//#endif


class SidebarCollectionViewController: UICollectionViewController, UIDocumentPickerDelegate, UICollectionViewDropDelegate, NSToolbarDelegate {
    struct Item: Hashable {
        let title: String?
        
        private let identifier = UUID()
    }
    let sections = ["Tools","Collections","Decks"]
    var collections = ["Collections"]
    var cdCollections: [Collection] = []
    var decks = ["Decks"]
    var cdDecks: [Deck] = []
    var search = ["Tools", "Search"]
    
    var addBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButton))
    
    var style: UICollectionLayoutListConfiguration.Appearance = .sidebar
    var dataSource: UICollectionViewDiffableDataSource<String, Item>! = nil
    
    convenience init(style: UICollectionLayoutListConfiguration.Appearance) {
        self.init()
        self.style = style
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dropDelegate = self
        if !(self.splitViewController?.traitCollection.horizontalSizeClass == .regular) {
            self.title = "Collections"
        }
        #if targetEnvironment(macCatalyst)
        self.navigationController?.navigationBar.isHidden = true
        //setupNSToolbar()
        #endif
        //navigationItem.title = "Collections"
        
        #if !targetEnvironment(macCatalyst)
        self.navigationItem.setRightBarButton(addBarButton, animated: true)
        let settingsButton = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: self, action: #selector(self.settings))
        self.navigationItem.setLeftBarButton(settingsButton, animated: true)
        #endif
        
        
        //first open
        if UserDefaultsHandler.isFirstTimeOpening(){
            firstTimeOpened()
        }
        
        createDataSource()
        #if targetEnvironment(macCatalyst)
        
        self.additionalSafeAreaInsets = UIEdgeInsets(top: 30, left: 0, bottom: 0, right: 0)
        self.navigationController?.navigationBar.isHidden = true
        //setupNSToolbar()
        #endif
    }
    override func viewWillAppear(_ animated: Bool) {
        
        if let nav = self.navigationController {
            nav.setToolbarHidden(true, animated: false)
            
        }
    }
    private func firstTimeOpened(){
        guard  let entity = NSEntityDescription.entity(forEntityName: "Collection", in:  CoreDataStack.handler.managedObjectContext) else {
            fatalError("Failed to decode Card")
        }
        let collection = Collection.init(entity: entity, insertInto: CoreDataStack.handler.managedObjectContext)
        collection.name = "Collection"
        let wishlist = Collection.init(entity: entity, insertInto: CoreDataStack.handler.managedObjectContext)
        wishlist.name = "Wish List"
        try? CoreDataStack.handler.managedObjectContext.save()
        UserDefaultsHandler.setExcludeOnlineOnly(exclude: true)
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
//    @objc func addButton(sender: Any) {
//        let menuAlert = UIAlertController(title: "Create Deck(s)", message: nil, preferredStyle: .actionSheet)
//        menuAlert.addAction(UIAlertAction(title: "New Empty Deck", style: .default, handler: {action in  self.addBlankDeck()}))
//        let pasteboard = UIPasteboard.general
//        if pasteboard.string != nil {
//            menuAlert.addAction(UIAlertAction(title: "New Deck from Clipboard", style: .default, handler: {action in  self.addDeckFromClipboard()}))
//        }
//        menuAlert.addAction(UIAlertAction(title: "New Deck(s) from File(s)", style: .default, handler: {action in  self.addDecksFromFiles()}))
//        menuAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//        if let sender = sender as? UIBarButtonItem {
//            menuAlert.popoverPresentationController?.barButtonItem = sender
//        }
////        else {
////            menuAlert.popoverPresentationController?.barButtonItem = addBarButton
////        }
//        #if targetEnvironment(macCatalyst)
//        if let sender = sender as? UIButton {
//            menuAlert.popoverPresentationController?.sourceView = sender
//        }
//        #endif
//        self.present(menuAlert, animated: true)
//    }
    @objc public func addButton() {
        let menuAlert = UIAlertController(title: "Create Deck(s)", message: nil, preferredStyle: .actionSheet)
        menuAlert.addAction(UIAlertAction(title: "New Empty Deck", style: .default, handler: {action in  self.addBlankDeck()}))
        let pasteboard = UIPasteboard.general
        if pasteboard.string != nil {
            menuAlert.addAction(UIAlertAction(title: "New Deck from Clipboard", style: .default, handler: {action in  self.addDeckFromClipboard()}))
        }
        menuAlert.addAction(UIAlertAction(title: "New Deck(s) from File(s)", style: .default, handler: {action in  self.addDecksFromFiles()}))
        menuAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//        if let sender = sender as? UIBarButtonItem {
            menuAlert.popoverPresentationController?.barButtonItem = addBarButton
//        }
        //        else {
        //            menuAlert.popoverPresentationController?.barButtonItem = addBarButton
        //        }
        #if targetEnvironment(macCatalyst)
       
        menuAlert.popoverPresentationController?.sourceView = collectionView.cellForItem(at: IndexPath(row: 0, section: 2))?.contentView
        
        #endif
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
                try? CoreDataStack.handler.managedObjectContext.save()
                self.reloadDecksFromCoreData()
                DispatchQueue.main.async {
                    self.reloadCollectionsFromCoreData()
                    self.createDataSource()
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
                    self.createDataSource()
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
            _ = url.startAccessingSecurityScopedResource()
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
                self.createDataSource()
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
    @objc func settings(){
        let storyboard = UIStoryboard(name: "Settings", bundle: nil)
        guard let settingsVC = storyboard.instantiateInitialViewController() as? SettingsTableViewController else {
            fatalError("Error going to settings")
        }
        //self.navigationController?.pushViewController(settingsVC, animated: true)
        self.present(settingsVC, animated: true, completion: nil)
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            return
        }
        if !(self.splitViewController?.traitCollection.horizontalSizeClass == .regular) {
            if indexPath.section == 0 {
                //StateCoordinator.shared.didSelectCollection(collection: "Search")
                self.navigationController?.pushViewController(CardListTableViewController.freshCardList(), animated: true)
            } else if indexPath.section == 2 {
                //StateCoordinator.shared.didSelectDeck(d: cdDecks[indexPath.row].objectID)
                self.navigationController?.pushViewController(DeckTableViewController.freshDeck(deck: cdDecks[indexPath.row-1].objectID), animated: true)
            } else if indexPath.section == 1 {
                //StateCoordinator.shared.didSelectCollection(collection: cdCollections[indexPath.row].objectID)
                self.navigationController?.pushViewController(CollectionTableViewController.freshCollection(collection: cdCollections[indexPath.row-1].objectID), animated: true)
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
                self.splitViewController?.setViewController(DeckTableViewController.freshDeck(deck: cdDecks[indexPath.row-1].objectID), for: .supplementary)
                
                self.splitViewController?.setViewController(nil, for: .secondary)
                self.splitViewController?.setViewController(DeckStatsTableViewController.refreshDeckStats(id: cdDecks[indexPath.row-1].objectID), for: .secondary)
                
            } else if indexPath.section == 1 {
                //StateCoordinator.shared.didSelectCollection(collection: cdCollections[indexPath.row].objectID)
                self.splitViewController?.setViewController(nil, for: .supplementary)
                self.splitViewController?.setViewController(CollectionTableViewController.freshCollection(collection: cdCollections[indexPath.row-1].objectID), for: .supplementary)
            }
        }
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return sections.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        if section == 2 {
            return cdDecks.count
        } else if section == 1 {
            return cdCollections.count
        } else {
            return sections[section].count - 1
        }
    }
    
    private func configureHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectionView)
        collectionView.delegate = self
    }
    private func createLayout() -> UICollectionViewLayout {
        let config = UICollectionLayoutListConfiguration(appearance: self.style)
        
        let list =  UICollectionViewCompositionalLayout.list(using: config)
        
        return list
    }
    func createDataSource() {
        reloadDecksFromCoreData()
        reloadCollectionsFromCoreData()
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, String> { (cell, indexPath, item) in
            var content = UIListContentConfiguration.sidebarCell()
            content.image = UIImage(named: "star")
            content.text = "\(item)"
            content.imageProperties.tintColor = .green
            content.textProperties.numberOfLines = 2
            cell.contentConfiguration = content
        }
        
        let headerRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Item> { (cell, indexPath, item) in
            var content = UIListContentConfiguration.sidebarCell()
            content.text = item.title
            content.textProperties.font = UIFont.preferredFont(forTextStyle: .headline)
            cell.contentConfiguration = content
        }
        
        dataSource = UICollectionViewDiffableDataSource<String, Item>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, item: Item) -> UICollectionViewCell? in
            
            if indexPath.item == 0 {
                let cell = collectionView.dequeueConfiguredReusableCell(using: headerRegistration, for: indexPath, item: item)
//                if indexPath.section == 2 {
//                    let headerDisclosureOption = UICellAccessory.OutlineDisclosureOptions(style: .header)
//                    cell.accessories = [.outlineDisclosure(options:headerDisclosureOption)]
//                }
                
                return cell
            } else {
                return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item.title)
            }
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<String, Item>()
        snapshot.appendSections(sections)
        for section in sections {
            var sectionSnapshot = NSDiffableDataSourceSectionSnapshot<Item>()
            let headerItem = Item(title: "\(section)")
            sectionSnapshot.append([headerItem])
            if section == "Tools" {
                sectionSnapshot.append([Item(title: "Search")], to: headerItem)
            } else if section == "Collections" {
                sectionSnapshot.append([Item(title: "Collection"), Item(title: "Wish List")], to: headerItem)
            } else {
                var decks: [Item] = []
                for deck in cdDecks {
                    decks.append(Item(title: deck.name))
                }
                sectionSnapshot.append(decks, to: headerItem)
            }
            sectionSnapshot.expand([headerItem])
            dataSource.apply(sectionSnapshot, to: section)
        }
        
    }
    override func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let edit = UIAction(title: "Edit",
                            image: UIImage(systemName: "pencil")) { _ in
            let deck = self.cdDecks[indexPath.row-1]
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
            CoreDataStack.handler.privateContext.delete(self.cdDecks[indexPath.row-1] as NSManagedObject)
            do {
                try CoreDataStack.handler.privateContext.save()
            } catch {
                print(error)
            }
            self.reloadDecksFromCoreData()
            DispatchQueue.main.async {
                
                self.createDataSource()
            }
        }
        
        return UIContextMenuConfiguration(identifier: nil,
                                          previewProvider: nil) { _ in
            UIMenu(title: "", children: [edit, delete])
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        if let indexPath = coordinator.destinationIndexPath {
            if indexPath.section == 2 {
                coordinator.session.loadObjects(ofClass: NSString.self) { items in
                    guard let strings = items as? [String] else { return }
                    for string in strings {
                        print(string)
                        let deck = self.cdDecks[indexPath.row-1]
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
                                try? CoreDataStack.handler.managedObjectContext.save()
                            }
                        } else {
                            if let card = card {
                                guard  let entity = NSEntityDescription.entity(forEntityName: "DeckCard", in:  CoreDataStack.handler.privateContext) else {
                                    fatalError("Failed to decode Card")
                                }
                                let deckCard = DeckCard.init(entity: entity, insertInto: CoreDataStack.handler.privateContext)
                                deckCard.card = card
                                deckCard.quantity = 1
                                self.cdDecks[indexPath.row-1].addToCards(deckCard)
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
                            self.cdCollections[indexPath.row-1].addToCards(collectionCard)
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
}
