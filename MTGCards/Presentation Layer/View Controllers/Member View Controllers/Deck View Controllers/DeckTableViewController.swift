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

class DeckTableViewController: UITableViewController, UIDocumentPickerDelegate {
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
        setUpSections()
        let importButton = UIBarButtonItem(image: UIImage(named: "import"), style: .plain, target: self, action: #selector(self.importDeck))
        self.navigationItem.setRightBarButton(importButton, animated: true)
        updateTitle()
    }
    override func viewWillDisappear(_ animated: Bool) {
        if let nav = self.navigationController {
            nav.setToolbarHidden(true, animated: true)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        //        let resetButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(resetFilters))
        //        let flexiableItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        //        let saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(applyFilters))
        let deckStatsButton = UIBarButtonItem(image: UIImage(named: "stats"), style: .plain, target: self, action: #selector(showDeckStats))
        if let nav = self.navigationController {
            nav.setToolbarHidden(false, animated: true)
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
            StateCoordinator.shared.didSelectDeckStats(d: id)
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
        let documentPicker = UIDocumentPickerViewController(documentTypes: [kUTTypePlainText as String], in: .import)
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
        return 55
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
                deck?.removeFromCards(card)
                CoreDataStack.handler.savePrivateContext()
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
        }
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == deckSection {
            if let card = deckCards[indexPath.row].card {
                StateCoordinator.shared.didSelectCard(id: card.objectID)
            }
        } else if indexPath.section == sideboardSection {
            if let card = sideboard[indexPath.row].card {
                StateCoordinator.shared.didSelectCard(id: card.objectID)
            }
        } else if indexPath.section == commanderSection {
            if let card = commander[indexPath.row].card {
                StateCoordinator.shared.didSelectCard(id: card.objectID)
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
