//
//  TokenListTableViewController.swift
//  MTGCards
//
//  Created by Joseph Smith on 7/8/21.
//

import UIKit
import CoreData
import SwiftUI

class TokenListTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate {

    
    var predicate: NSPredicate?
    var fetchedResultsController: NSFetchedResultsController<Token>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.insetsContentViewsToSafeArea = true
        tableView.keyboardDismissMode = .onDrag
        loadSavedData()
        if navigationItem.searchController == nil {
            let search = UISearchController(searchResultsController: nil)
            search.obscuresBackgroundDuringPresentation = false
            search.searchBar.placeholder = "Search"
            search.searchResultsUpdater = self
            search.hidesNavigationBarDuringPresentation = false
            search.searchBar.delegate = self
            navigationItem.searchController = search
            self.navigationItem.hidesSearchBarWhenScrolling = false
        }
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationItem.largeTitleDisplayMode = .never
    }
    override func viewWillAppear(_ animated: Bool) {
        
        if let nav = self.navigationController {
            nav.setToolbarHidden(true, animated: false)
            
        }
    }
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections![section].numberOfObjects
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tokenCell", for: indexPath)
        
        let token = fetchedResultsController.object(at: indexPath)
        
        var effectiveName = "";
        if let name = token.name {
            if name.contains("//") {
                let parts = name.components(separatedBy: " // ")
                if token.side == "a" {
                    effectiveName = parts.first ?? ""
                } else {
                    effectiveName = parts[1]
                }
            } else {
                effectiveName = token.name ?? ""
            }
        }
        // Configure the cell...
        cell.textLabel?.text = effectiveName
        cell.detailTextLabel?.text = token.set.name
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !(self.splitViewController?.traitCollection.horizontalSizeClass == .regular) {
            let vc = UIHostingController(rootView: TokenView(token: fetchedResultsController.object(at: indexPath)))
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            self.splitViewController?.setViewController(nil, for: .secondary)
            let vc = UIHostingController(rootView: TokenView(token: fetchedResultsController.object(at: indexPath)))
            self.splitViewController?.setViewController(vc, for: .secondary)
        }
    }
    
    func loadSavedData(){
        if fetchedResultsController == nil {
            let request = createFetchRequest()
            let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
            let sortDescriptor2 = NSSortDescriptor(key: "set.name", ascending: true)
            request.sortDescriptors = [sortDescriptor, sortDescriptor2]
            request.predicate = predicate
            request.fetchBatchSize = 30
            fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataStack.handler.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
            fetchedResultsController.delegate = self
        }
        fetchedResultsController.fetchRequest.predicate = predicate
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
    private func createFetchRequest() -> NSFetchRequest<Token> {
        let fetchRequest: NSFetchRequest<Token> = NSFetchRequest<Token>(entityName: "Token")
        return fetchRequest
    }
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text, text.count > 0 else {
            predicate = nil
            loadSavedData()
            return
        }
        predicate = NSPredicate(format: "name contains[c] %@", text)
        loadSavedData()
        return
    }
}
extension TokenListTableViewController {
    static func freshTokenList() -> TokenListTableViewController {
        let storyboard = UIStoryboard(name: "TokenList", bundle: nil)
        guard let filelist = storyboard.instantiateInitialViewController() as? TokenListTableViewController else {
            fatalError("Project config error - storyboard doesnt provide a TokenList")
        }
        return filelist
    }
}
