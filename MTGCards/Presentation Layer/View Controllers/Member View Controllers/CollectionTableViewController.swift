//
//  CollectionTableViewController.swift
//  MTGCards
//
//  Created by Joseph Smith on 3/16/19.
//  Copyright © 2019 Robotic Snail Software. All rights reserved.
//

import UIKit
import CoreData

class CollectionTableViewController: UITableViewController, UIContextMenuInteractionDelegate {
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        return nil
    }
    
    var collection: Collection? = nil
    
    var collectionCards: [CollectionCard] {
        get {
            if let d = collection {
                if let sb = d.cards?.allObjects as? [CollectionCard]
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
        tableView.tableFooterView = UIView()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collectionCards.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "collectionCard", for: indexPath) as! CollectionTableViewCell
        let collectionCard: CollectionCard = collectionCards[indexPath.row]
        cell.title?.text = collectionCard.card?.name
        cell.subtitle?.text = collectionCard.card?.set.name
        cell.backgroundColor = nil
        if let colorIdentities = collectionCard.card?.colorIdentity?.allObjects as? [ColorIdentity] {
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
                if collectionCard.card?.type == "Land" {
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
        if let card = collectionCards[indexPath.row].card {
            StateCoordinator.shared.didSelectCard(id: card.objectID)
        }
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let card: CollectionCard? = collectionCards[indexPath.row]
            if let card = card {
                collection?.removeFromCards(card)
                CoreDataStack.handler.privateContext.delete(card)
                do {
                    try CoreDataStack.handler.privateContext.save()
                } catch {
                    print(error)
                }
                if let id = collection?.objectID {
                    collection = CoreDataStack.handler.privateContext.object(with: id) as? Collection
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    
                }
            }
        }
    }
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        guard UIApplication.shared.applicationState == .inactive else {
            return
        }
        
        print("Called")
    }
    override func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let addTo = UIAction(title: "Add To...",
                             image: UIImage(systemName: "plus")) { action in
                                if let card = self.collectionCards[indexPath.row].card {
                                    let alert = UIAlertController(title: "Add To", message: nil, preferredStyle: .actionSheet)
                                    
                                    if let popoverController = alert.popoverPresentationController {
                                        popoverController.permittedArrowDirections = UIPopoverArrowDirection.up
                                        popoverController.sourceView = tableView.cellForRow(at: indexPath)
                                    }
                                    let addToCollection = UIAlertAction(title: "Collection", style: .default, handler: { action in
                                        DataManager.addCardToCollection(id: card.objectID)
                                    })
                                    alert.addAction(addToCollection)
                                    let addToWishList = UIAlertAction(title: "Wish List", style: .default, handler: { action in
                                        DataManager.addCardToWishList(id: card.objectID)
                                    })
                                    alert.addAction(addToWishList)
                                    let addToDeck = UIAlertAction(title: "Deck...", style: .default, handler: { action in
                                        self.present(Sharing.addToDeckMenu(id: card.objectID, sourceView: tableView.cellForRow(at: indexPath)), animated: true)
                                    })
                                    alert.addAction(addToDeck)
                                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
                                        self.dismiss(animated: true, completion: nil)
                                    }))
                                    if let popoverController = alert.popoverPresentationController {
                                        popoverController.permittedArrowDirections = UIPopoverArrowDirection.up
                                        popoverController.sourceView = tableView.cellForRow(at: indexPath)
                                    }
                                    self.present(alert, animated: true, completion: nil)
                                }
        }
        let share = UIAction(title: "Share",
                             image: UIImage(systemName: "square.and.arrow.up")) { action in
                                if let card = self.collectionCards[indexPath.row].card {
                                    
                                    let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                                    let imageAction = UIAlertAction(title: "Image", style: .default, handler: { action in
                                        if let uuid = card.uuid {
                                            if let image = self.getImage(Key: uuid) {
                                                self.present(Sharing.shareImage(image: image, self.tableView.cellForRow(at: indexPath)?.contentView), animated: true)
                                            }
                                        }
                                        
                                    })
                                    imageAction.setValue(UIImage(systemName: "photo"), forKey: "image")
                                    imageAction.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
                                    alert.addAction(imageAction)
                                    if card.multiverseID > 0 {
                                        alert.addAction(UIAlertAction(title: "Gatherer", style: .default, handler: { action in
                                            if let url = URL(string:  "http://gatherer.wizards.com/Pages/Card/Details.aspx?multiverseid=\(card.multiverseID)"){
                                                self.present(Sharing.shareUrl(url: url, self.tableView.cellForRow(at: indexPath)?.contentView), animated: true)
                                            }
                                        }))
                                    }
                                    if let tcg = card.tcgplayerPurchaseURL {
                                        alert.addAction(UIAlertAction(title: "TCGPlayer", style: .default, handler: { action in
                                            //self.shareText(text: tcg)
                                            if let url = URL(string:  tcg){
                                                self.present(Sharing.shareUrl(url: url, self.tableView.cellForRow(at: indexPath)), animated: true)
                                            }
                                        }))
                                    }
                                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
                                        self.dismiss(animated: true, completion: nil)
                                    }))
                                    if let popoverController = alert.popoverPresentationController {
                                        popoverController.permittedArrowDirections = UIPopoverArrowDirection.up
                                        popoverController.sourceView = tableView.cellForRow(at: indexPath)
                                    }
                                    self.present(alert, animated: true, completion: nil)
                                }
        }
        let delete = UIAction(title: "Delete",
                              image: UIImage(systemName: "trash.fill"),
                              attributes: [.destructive]) { action in
                                let card = self.collectionCards[indexPath.row]
                                
                                //let card = deckCards[indexPath.row]
                                self.collection?.removeFromCards(card)
                                    
                                    CoreDataStack.handler.savePrivateContext()
                                    if let id = self.collection?.objectID {
                                        self.collection = CoreDataStack.handler.privateContext.object(with: id) as? Collection
                                    }
                                    DispatchQueue.main.async {
                                        self.tableView.reloadData()
                                    }
                                
        }
        return UIContextMenuConfiguration(identifier: nil,
                                          previewProvider: nil) { _ in
                                            UIMenu(title: "", children: [addTo, share, delete])
        }

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
extension CollectionTableViewController {
    static func freshCollection(collection: NSManagedObjectID) -> CollectionTableViewController {
        let storyboard = UIStoryboard(name: "Collection", bundle: nil)
        guard let collectionVC = storyboard.instantiateInitialViewController() as? CollectionTableViewController else {
            fatalError("Project config error - storyboard doesnt provide a FileListVC")
        }
        if let c = CoreDataStack.handler.privateContext.object(with: collection) as? Collection {
            collectionVC.collection = c
            collectionVC.title = c.name
        }
        
        return collectionVC
    }
}
