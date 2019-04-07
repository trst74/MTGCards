//
//  CollectionTableViewController.swift
//  MTGCards
//
//  Created by Joseph Smith on 3/16/19.
//  Copyright © 2019 Robotic Snail Software. All rights reserved.
//

import UIKit

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

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return collectionCards.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "collectionCard", for: indexPath) as! CollectionTableViewCell
        var collectionCard: CollectionCard = collectionCards[indexPath.row]
        
        //let deckCard = deckCards[indexPath.row]
        cell.title?.text = collectionCard.card?.name
        cell.subtitle?.text = collectionCard.card?.set.name

        
        cell.backgroundColor = nil
        if let identities = collectionCard.card?.colorIdentity {
            
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
                if collectionCard.card?.type == "Land" {
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
        if let card = collectionCards[indexPath.row].card {
            StateCoordinator.shared.didSelectCard(c: card)
        }
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let card: CollectionCard? = collectionCards[indexPath.row]
            if let card = card {
                collection?.removeFromCards(card)
                CoreDataStack.handler.saveContext()
                if let id = collection?.objectID {
                    collection = CoreDataStack.handler.managedObjectContext.object(with: id) as? Collection
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    
                }
            }
        }
    }
}
extension CollectionTableViewController {
    static func freshCollection(collection: Collection) -> CollectionTableViewController {
        let storyboard = UIStoryboard(name: "Collection", bundle: nil)
        guard let collectionVC = storyboard.instantiateInitialViewController() as? CollectionTableViewController else {
            fatalError("Project config error - storyboard doesnt provide a FileListVC")
        }
        collectionVC.collection = collection
        return collectionVC
    }
}
