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
                if let sb = d.cards?.filter({ ($0 as? DeckCard)?.isSideboard == false }) as? [DeckCard]
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
    override func viewDidLoad() {
        super.viewDidLoad()
        // share button
        //        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(self.share))
        //        self.navigationItem.setRightBarButton(shareButton, animated: true)
        // import button
        let importButton = UIBarButtonItem(image: UIImage(named: "import"), style: .plain, target: self, action: #selector(self.importDeck))
        self.navigationItem.setRightBarButton(importButton, animated: true)
        updateTitle()
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
    // MARK: - Table view data source
    @objc private func share(){
        print("share")
    }
    @objc private func importDeck(){
        print("import")
        let documentPicker = UIDocumentPickerViewController(documentTypes: [kUTTypePlainText as String], in: .import)
        //Call Delegate
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
            guard  let entity = NSEntityDescription.entity(forEntityName: "DeckCard", in:  CoreDataStack.handler.managedObjectContext) else {
                fatalError("Failed to decode Card")
            }
            let deckCard = DeckCard.init(entity: entity, insertInto: CoreDataStack.handler.managedObjectContext)
            deckCard.card = card
            deckCard.quantity = Int16(quantity)
            deckCard.isSideboard = isSideboard
            deck?.addToCards(deckCard)
            CoreDataStack.handler.saveContext()
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
        }
        let compound = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        request.predicate = compound
        let sortDescriptor = NSSortDescriptor(key: "set.releaseDate", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        do {
            let results = try CoreDataStack.handler.managedObjectContext.fetch(request)
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
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Main Deck"
        } else {
            return "Sideboard"
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return deckCards.count
        } else {
            return sideboard.count
        }
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
            if indexPath.section == 1 {
                card = deckCards[indexPath.row]
            } else {
                card = sideboard[indexPath.row]
            }
            //let card = deckCards[indexPath.row]
            if let card = card {
                deck?.removeFromCards(card)
                CoreDataStack.handler.saveContext()
                if let id = deck?.objectID {
                    deck = CoreDataStack.handler.managedObjectContext.object(with: id) as? Deck
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
        if indexPath.section == 0 {
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
                if deckCard?.card?.type == "Land" {
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
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            
            if let card = deckCards[indexPath.row].card {
                StateCoordinator.shared.didSelectCard(c: card)
            }
        } else if indexPath.section == 1 {
            if let card = sideboard[indexPath.row].card {
                StateCoordinator.shared.didSelectCard(c: card)
            }
        }
        
    }
}
extension DeckTableViewController {
    static func freshDeck(deck: Deck) -> DeckTableViewController {
        let storyboard = UIStoryboard(name: "Deck", bundle: nil)
        guard let decklist = storyboard.instantiateInitialViewController() as? DeckTableViewController else {
            fatalError("Project config error - storyboard doesnt provide a FileListVC")
        }
        decklist.deck = deck
        return decklist
    }
}
