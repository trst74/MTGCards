//
//  CollectionTableViewController.swift
//  MTGCards
//
//  Created by Joseph Smith on 3/16/19.
//  Copyright © 2019 Robotic Snail Software. All rights reserved.
//

import UIKit
import CoreData

class CollectionTableViewController: UITableViewController {
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
