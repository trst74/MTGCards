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

class CardListTableViewController: UITableViewController, UISearchResultsUpdating, NSFetchedResultsControllerDelegate, UITableViewDragDelegate, UIContextMenuInteractionDelegate {
    
    
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
        let filterButton = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3.decrease.circle"), style: .plain, target: self, action: #selector(self.filter))
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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
                if card.type == "Land" {
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
        if card.frameEffects?.count ?? 0 > 0 {
            if card.frameEffects?.count == 1 && (card.frameEffects?.allObjects[0] as? CardFrameEffect)?.effect == "legendary" {
                cell.frameEffectIndicator.text = ""
            } else {
                print((card.frameEffects?.allObjects[0] as? CardFrameEffect)?.effect ?? "")
                cell.frameEffectIndicator.text = "✨"
            }
        } else if card.borderColor == "borderless" || card.isFullArt {
            cell.frameEffectIndicator.text = "✨"
        } else {
            cell.frameEffectIndicator.text = ""
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
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        return nil
    }
    override func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let addTo = UIAction(title: "Add To...",
                             image: UIImage(systemName: "plus")) { action in
                                let card = self.fetchedResultsController.object(at: indexPath)
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
        let share = UIAction(title: "Share",
                             image: UIImage(systemName: "square.and.arrow.up")) { action in
                                let card = self.fetchedResultsController.object(at: indexPath)
                                
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
        return UIContextMenuConfiguration(identifier: nil,
                                          previewProvider: nil) { _ in
                                            UIMenu(title: "", children: [addTo, share])
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
extension CardListTableViewController {
    static func freshCardList() -> CardListTableViewController {
        let storyboard = UIStoryboard(name: "CardList", bundle: nil)
        guard let filelist = storyboard.instantiateInitialViewController() as? CardListTableViewController else {
            fatalError("Project config error - storyboard doesnt provide a FileListVC")
        }
        return filelist
    }
}
