//
//  DeckTableViewController.swift
//  MTGCards
//
//  Created by Joseph Smith on 3/14/19.
//  Copyright © 2019 Robotic Snail Software. All rights reserved.
//

import UIKit
import CoreData
import MobileCoreServices
import UniformTypeIdentifiers
import SwiftUI

class DeckTableViewController: UITableViewController, UIDocumentPickerDelegate, UIContextMenuInteractionDelegate {
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        return nil
    }
    
    var deck: Deck? = nil
    var deckCards: [DeckCard] {
        get {
            if let d = deck {
                if let sb = d.cards?.filter({ ($0 as? DeckCard)?.isSideboard == false && ($0 as? DeckCard)?.isCommander == false}) as? [DeckCard]
                {
                    return sb.sorted {
                        if let n1 = $0.card?.name, let n2 = $1.card?.name {
                            return n1 < n2
                        }
                        return false
                    }
                }
            }
            return []
        }
    }
    var sideboard : [DeckCard] {
        get {
            if let d = deck {
                if let sb = d.cards?.filter({ ($0 as? DeckCard)?.isSideboard == true }) as? [DeckCard]
                {
                    return sb.sorted {
                        if let n1 = $0.card?.name, let n2 = $1.card?.name {
                            return n1 < n2
                        }
                        return false
                    }
                }
            }
            return []
        }
    }
    var commander : [DeckCard] {
        get {
            if let d = deck {
                if let sb = d.cards?.filter({ ($0 as? DeckCard)?.isCommander == true }) as? [DeckCard]
                {
                    return sb.sorted {
                        if let n1 = $0.card?.name, let n2 = $1.card?.name {
                            return n1 < n2
                        }
                        return false
                    }
                }
            }
            return []
        }
    }
    var commanderSection = -1
    var deckSection =  0
    var sideboardSection = -1
    var numberOfSections = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        tableView.tableFooterView = UIView()
        setUpSections()
        let importButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.down"), style: .plain, target: self, action: #selector(self.importDeck))
        self.navigationItem.setRightBarButton(importButton, animated: true)
        updateTitle()
//        for card in deck?.cards?.allObjects as! [DeckCard] {
//            print("\(card.quantity) \(String(describing: card.card?.name ?? "")) (\(card.card?.set.code ?? ""))")
//        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        if let nav = self.navigationController {
            nav.setToolbarHidden(true, animated: false)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        //        let resetButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(resetFilters))
        //        let flexiableItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        //        let saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(applyFilters))
        let deckStatsButton = UIBarButtonItem(image: UIImage(systemName: "chart.bar.fill"), style: .plain, target: self, action: #selector(showDeckStats))
        if let nav = self.navigationController {
            nav.setToolbarHidden(false, animated: false)
            toolbarItems = [deckStatsButton]
        }
    }
    func setUpSections(){
        commanderSection = -1
        deckSection = 0
        sideboardSection = -1
        numberOfSections = 0
        
        if commander.count > 0 {
            commanderSection = 0
            numberOfSections += 1
            deckSection = 1
            numberOfSections += 1
        }
        if sideboard.count > 0 {
            sideboardSection = deckSection + 1
            numberOfSections += 1
        }
    }
    @objc func showDeckStats(){
        if let id = deck?.objectID {
//            if !(self.splitViewController?.traitCollection.horizontalSizeClass == .regular) {
//                self.navigationController?.pushViewController(DeckStatsTableViewController.refreshDeckStats(id: id), animated: true)
//            } else {
//                self.splitViewController?.setViewController(nil, for: .secondary)
//                self.splitViewController?.setViewController(DeckStatsTableViewController.refreshDeckStats(id: id), for: .secondary)
//            }
            if !(self.splitViewController?.traitCollection.horizontalSizeClass == .regular) {
                let vc = UIHostingController(rootView: DeckStatsView(deck: deck))
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                self.splitViewController?.setViewController(nil, for: .secondary)
                let vc = UIHostingController(rootView: DeckStatsView(deck: deck))
                self.splitViewController?.setViewController(vc, for: .secondary)
            }
        }
    }
    private func updateTitle(){
        let name = deck?.name
        let cardTotal = deck?.cards?.reduce(0){
            if let c2 = $1 as? DeckCard {
                if let q0 = $0 {
                    let q2 = Int(c2.quantity)
                    return q0 + q2
                }
            }
            return 0
        }
        if let total = cardTotal, let n = name {
            self.title = "\(n) (\(total))"
        }
    }
    @objc private func share(){
        print("share")
    }
    @objc private func importDeck(){
        print("import")
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.text])
        documentPicker.delegate = self
        self.present(documentPicker, animated: true)
        updateTitle()
    }
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        print(urls)
        importFile(url: urls[0])
    }
    private func importFile(url: URL){
        do {
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
                    addCard(name: name, setCode: setCode, quantity: Int(quantity) ?? 1, isSideboard: isSideboard)
                } else if previousline == "" {
                    print("sideboard start")
                    isSideboard = true
                }
                previousline = line
            }
            DispatchQueue.main.async {
                self.setUpSections()
                self.tableView.reloadData()
                
                self.updateTitle()
            }
        } catch {
            print(error)
        }
        
    }
    private func addCard(name: String, setCode: String, quantity: Int, isSideboard: Bool){
        let card = getCard(name: name, setCode: setCode)
        if let card = card {
            guard  let entity = NSEntityDescription.entity(forEntityName: "DeckCard", in:  CoreDataStack.handler.privateContext) else {
                fatalError("Failed to decode Card")
            }
            let deckCard = DeckCard.init(entity: entity, insertInto: CoreDataStack.handler.privateContext)
            deckCard.card = card
            deckCard.quantity = Int16(quantity)
            deckCard.isSideboard = isSideboard
            deck?.addToCards(deckCard)
            do {
                try CoreDataStack.handler.privateContext.save()
            } catch {
                print(error)
            }
            
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
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == commanderSection {
            return "Commander"
        } else if section == deckSection {
            return "Main Deck"
        } else if section == sideboardSection {
            return "Sideboard"
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == commanderSection {
            return commander.count
        } else if section == deckSection {
            return deckCards.count
        } else if section == sideboardSection {
            return sideboard.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height: CGFloat = 55.0
        #if targetEnvironment(macCatalyst)
        height = 50.0
        #endif
        return height
    }
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            var card: DeckCard? = nil
            if indexPath.section == commanderSection {
                card = commander[indexPath.row]
            } else if indexPath.section == deckSection {
                card = deckCards[indexPath.row]
            } else {
                card = sideboard[indexPath.row]
            }
            //let card = deckCards[indexPath.row]
            if let card = card {
                DataManager.removeCardFromDeck(cardId: card.objectID)
                if let id = deck?.objectID {
                    deck = CoreDataStack.handler.privateContext.object(with: id) as? Deck
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "deckCard", for: indexPath) as! DeckTableViewCell
        cell.layer.borderWidth = 0
        var deckCard: DeckCard? = nil
        if indexPath.section == commanderSection {
            deckCard = commander[indexPath.row]
        } else if indexPath.section == deckSection {
            deckCard = deckCards[indexPath.row]
        } else {
            deckCard = sideboard[indexPath.row]
        }
        //let deckCard = deckCards[indexPath.row]
        cell.title?.text = deckCard?.card?.name
        cell.subtitle?.text = deckCard?.card?.set.name
        if let quantity = deckCard?.quantity {
            cell.quantity.text = "\(quantity)"
        }
        
        cell.backgroundColor = nil
        if let colorIdentities = deckCard?.card?.colorIdentity?.allObjects as? [ColorIdentity] {
            let identities: [String?] = colorIdentities.map ({ $0.color })
            var colors: [UIColor] = []
            if identities.contains("W") {
                colors.append(UIColor(named: "Plains") ?? UIColor.white)
            }
            if identities.contains("U") {
                colors.append(UIColor(named: "Islands") ?? UIColor.white)
            }
            if identities.contains("B") {
                colors.append(UIColor(named: "Swamps") ?? UIColor.white)
            }
            if identities.contains("R") {
                colors.append(UIColor(named: "Mountains") ?? UIColor.white)
            }
            if identities.contains("G") {
                colors.append(UIColor(named: "Forests") ?? UIColor.white)
            }
            if colors.count == 0 {
                if deckCard?.card?.type == "Land" {
                    colors = [UIColor(named: "Lands") ?? UIColor.white]
                    
                } else {
                    colors = [UIColor(named: "Artifacts") ?? UIColor.white]
                }
            }
            if colors.count == 1 {
                colors += colors
            }
            cell.gradientView?.colors = colors
            
            if let card = deckCard?.card, let format = deck?.format {
                if !checkCardLegality(card: card, legality: format) {
                    cell.layer.borderWidth = 2
                    cell.layer.borderColor = UIColor.red.cgColor
                }
            }
        }
        
        return cell
    }
    private func checkCardLegality(card: Card, legality: String) -> Bool {
        switch legality {
        case "Standard":
          return card.legalities?.standard == "Legal"
        case "Pioneer":
            return card.legalities?.pioneer == "Legal"
        case "Modern":
            return card.legalities?.modern == "Legal"
        case "Legacy":
            return card.legalities?.legacy == "Legal"
        case "Vintage":
            return card.legalities?.vintage == "Legal"
        case "Commander":
            return card.legalities?.commander == "Legal"
        case "Frontier":
            return card.legalities?.frontier == "Legal"
        case "Pauper":
            return card.legalities?.pauper == "Legal"
        case "Penny":
            return card.legalities?.penny == "Legal"
        case "Duel":
            return card.legalities?.duel == "Legal"
        default:
            return false
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var card: Card? = nil
        if indexPath.section == deckSection {
            if let c = deckCards[indexPath.row].card {
                card = c
            }
        } else if indexPath.section == sideboardSection {
            if let c = sideboard[indexPath.row].card {
                card = c
            }
        } else if indexPath.section == commanderSection {
            if let c = commander[indexPath.row].card {
                card = c
            }
        }
        if let card = card {
            if !(self.splitViewController?.traitCollection.horizontalSizeClass == .regular) {
                let vc = UIHostingController(rootView: CardVC(card: card))
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                self.splitViewController?.setViewController(nil, for: .secondary)
                let vc = UIHostingController(rootView: CardVC(card: card))
                self.splitViewController?.setViewController(vc, for: .secondary)
            }
        }
    }
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: "Edit") {
            (contextaction: UIContextualAction, sourceView: UIView, completionHandler: (Bool) -> Void) in
            
            var deckcard: DeckCard?
            if indexPath.section == self.deckSection {
                deckcard = self.deckCards[indexPath.row]
            } else if indexPath.section == self.sideboardSection {
                deckcard = self.sideboard[indexPath.row]
            } else if indexPath.section == self.commanderSection {
                deckcard = self.commander[indexPath.row]
            }
            let storyboard = UIStoryboard(name: "EditDeckCard", bundle: nil)
            guard let editDeckCardView = storyboard.instantiateInitialViewController() as? EditDeckCardTableViewController else {
                fatalError("Project config error - storyboard doesnt provide a EditDeckCard")
            }
            if let deckcard = deckcard {
                editDeckCardView.deckCard = deckcard
            }
            editDeckCardView.deckViewController = self
            self.navigationController?.pushViewController(editDeckCardView, animated: true)
            completionHandler(true)
        }
        editAction.backgroundColor = .gray
        return UISwipeActionsConfiguration(actions: [editAction])
    }
    override func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let edit = UIAction(title: "Edit",
                            image: UIImage(systemName: "pencil")) { _ in
                                let deckcard = self.getDeckcardForIndexPath(indexPath: indexPath)
                                let storyboard = UIStoryboard(name: "EditDeckCard", bundle: nil)
                                guard let editDeckCardView = storyboard.instantiateInitialViewController() as? EditDeckCardTableViewController else {
                                    fatalError("Project config error - storyboard doesnt provide a EditDeckCard")
                                }
                                if let deckcard = deckcard {
                                    editDeckCardView.deckCard = deckcard
                                }
                                editDeckCardView.deckViewController = self
                                self.navigationController?.pushViewController(editDeckCardView, animated: true)
                                
        }
        let addTo = UIAction(title: "Add To...",
                             image: UIImage(systemName: "plus")) { action in
                                let deckcard = self.getDeckcardForIndexPath(indexPath: indexPath)
                                let alert = UIAlertController(title: "Add To", message: nil, preferredStyle: .actionSheet)
                                
                                if let popoverController = alert.popoverPresentationController {
                                    popoverController.permittedArrowDirections = UIPopoverArrowDirection.up
                                    popoverController.sourceView = tableView.cellForRow(at: indexPath)
                                    //popoverController.sourceRect = tableView.cellForRow(at: indexPath)?.bounds
                                }
                                
                                let addToCollection = UIAlertAction(title: "Collection", style: .default, handler: { action in
                                    if let id = deckcard?.card?.objectID {
                                        DataManager.addCardToCollection(id: id)
                                    }
                                })
                                alert.addAction(addToCollection)
                                let addToWishList = UIAlertAction(title: "Wish List", style: .default, handler: { action in
                                    if let id = deckcard?.card?.objectID {
                                        DataManager.addCardToWishList(id: id)
                                    }
                                })
                                alert.addAction(addToWishList)
                                let addToDeck = UIAlertAction(title: "Deck...", style: .default, handler: { action in
                                    if let id = deckcard?.card?.objectID {
                                        self.presentAddToDeckMenu(id: id, sourceView: tableView.cellForRow(at: indexPath))
                                    }
                                })
                                alert.addAction(addToDeck)
                                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
                                    
                                    self.dismiss(animated: true, completion: nil)
                                }))
                                if let popoverController = alert.popoverPresentationController {
                                    popoverController.permittedArrowDirections = UIPopoverArrowDirection.up
                                    popoverController.sourceView = tableView.cellForRow(at: indexPath)
                                    //popoverController.sourceRect = tableView.cellForRow(at: indexPath)?.bounds
                                }
                                self.present(alert, animated: true, completion: nil)
                                
        }
        let share = UIAction(title: "Share",
                             image: UIImage(systemName: "square.and.arrow.up")) { action in
                                let deckcard = self.getDeckcardForIndexPath(indexPath: indexPath)
                                
                                let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                                let imageAction = UIAlertAction(title: "Image", style: .default, handler: { action in
                                    if let uuid = deckcard?.card?.uuid {
                                        if let image = self.getImage(Key: uuid) {
                                            self.shareImage(image: image, popupView: self.tableView.cellForRow(at: indexPath))
                                        }
                                    }
                                    
                                })
                                imageAction.setValue(UIImage(systemName: "photo"), forKey: "image")
                                imageAction.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
                                alert.addAction(imageAction)
                                if let multiverseid = deckcard?.card?.multiverseID, multiverseid > 0 {
                                    alert.addAction(UIAlertAction(title: "Gatherer", style: .default, handler: { action in
                                        if let url = URL(string:  "http://gatherer.wizards.com/Pages/Card/Details.aspx?multiverseid=\(multiverseid)"){
                                            self.shareUrl(url: url, popupView: self.tableView.cellForRow(at: indexPath))
                                        }
                                    }))
                                }
                                if let tcg = deckcard?.card?.tcgplayerPurchaseURL {
                                    alert.addAction(UIAlertAction(title: "TCGPlayer", style: .default, handler: { action in
                                        //self.shareText(text: tcg)
                                        if let url = URL(string:  tcg){
                                            self.shareUrl(url: url, popupView: self.tableView.cellForRow(at: indexPath))
                                        }
                                        
                                    }))
                                }
                                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
                                    
                                    self.dismiss(animated: true, completion: nil)
                                }))
                                if let popoverController = alert.popoverPresentationController {
                                    popoverController.permittedArrowDirections = UIPopoverArrowDirection.up
                                    popoverController.sourceView = tableView.cellForRow(at: indexPath)
                                    //popoverController.sourceRect = tableView.cellForRow(at: indexPath)?.bounds
                                }
                                self.present(alert, animated: true, completion: nil)
        }
        
        let delete = UIAction(title: "Delete",
                              image: UIImage(systemName: "trash.fill"),
                              attributes: [.destructive]) { action in
                                let card = self.getDeckcardForIndexPath(indexPath: indexPath)
                                if let card = card {
                                    DataManager.removeCardFromDeck(cardId: card.objectID)
                                    if let id = self.deck?.objectID {
                                        self.deck = CoreDataStack.handler.privateContext.object(with: id) as? Deck
                                    }
                                    DispatchQueue.main.async {
                                        self.tableView.reloadData()
                                    }
                                }
        }
        
        return UIContextMenuConfiguration(identifier: nil,
                                          previewProvider: nil) { _ in
                                            UIMenu(title: "", children: [edit,addTo, share, delete])
        }
    }
    func presentAddToDeckMenu(id: NSManagedObjectID, sourceView: UITableViewCell?){
        let alert = UIAlertController(title: "Add To Deck...", message: nil, preferredStyle: .actionSheet)
        let decks = DataManager.getDecksFromCoreData()
        for d in decks {
            alert.addAction(UIAlertAction(title: d.name ?? "", style: .default, handler: { action in
                DataManager.addCardToDeck(deckId: d.objectID, cardId: id)
            }))
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            self.dismiss(animated: true, completion: nil)
        }))
        if let popoverController = alert.popoverPresentationController {
            popoverController.permittedArrowDirections = UIPopoverArrowDirection.up
            popoverController.sourceView = sourceView
            //popoverController.sourceRect = tableView.cellForRow(at: indexPath)?.bounds
        }
        self.present(alert, animated: true, completion: nil)
    }
    func getDeckcardForIndexPath(indexPath: IndexPath) -> DeckCard? {
        var deckcard: DeckCard?
        if indexPath.section == self.deckSection {
            deckcard = self.deckCards[indexPath.row]
        } else if indexPath.section == self.sideboardSection {
            deckcard = self.sideboard[indexPath.row]
        } else if indexPath.section == self.commanderSection {
            deckcard = self.commander[indexPath.row]
        }
        return deckcard
    }
    func shareUrl(url: URL, popupView: AnyObject?){
        let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: [SafariActivity()])
        if let location = popupView as? UIView {
            activityViewController.popoverPresentationController?.sourceView = location
        } else {
            activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        }
        self.present(activityViewController, animated: true, completion: nil)
    }
    func shareImage(image: UIImage, popupView: AnyObject?){
        
        let imageToShare = [ image ]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        if let location = popupView as? UIView {
            activityViewController.popoverPresentationController?.sourceView = location
        } else {
            activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        }
        self.present(activityViewController, animated: true, completion: nil)
    }
    func getImage(Key: String) -> UIImage? {
        let fileManager = FileManager.default
        let filename = getDocumentsDirectory().appendingPathComponent("\(Key).png")
        if fileManager.fileExists(atPath: filename.path) {
            print("loaded from cache")
            return UIImage(contentsOfFile: filename.path)
        }
        return nil
    }
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
extension DeckTableViewController {
    static func freshDeck(deck: NSManagedObjectID) -> DeckTableViewController {
        let storyboard = UIStoryboard(name: "Deck", bundle: nil)
        guard let decklist = storyboard.instantiateInitialViewController() as? DeckTableViewController else {
            fatalError("Project config error - storyboard doesnt provide a FileListVC")
        }
        if let d = CoreDataStack.handler.privateContext.object(with: deck) as? Deck {
            decklist.deck = d
            decklist.title = d.name
        }
        
        return decklist
    }
}
