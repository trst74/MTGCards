//
//  AbilityFilterTableViewController.swift
//  MTGCards
//
//  Created by Joseph Smith on 12/7/20.
//  Copyright © 2020 Robotic Snail Software. All rights reserved.
//

import UIKit
import CoreData

class KeywordFilterTableViewController: UITableViewController {

    var filterController: FiltersTableViewController? = nil
    
    var keywords: [String] = []
    var selectedKeywords: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        DispatchQueue.main.async {
            self.getKeywords()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        
        if let nav = self.navigationController {
            nav.setToolbarHidden(true, animated: false)
            
        }
    }
    func getKeywords(){
        let request = NSFetchRequest<CardKeyword>(entityName: "CardKeyword")
        let sortDescriptor = NSSortDescriptor(key: "keyword", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        do {
            let results = try CoreDataStack.handler.managedObjectContext.fetch(request)
            keywords = Array(Set(results.map { $0.keyword ?? "" })).sorted()
            self.tableView.reloadData()
        } catch {
            print(error)
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return keywords.count
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height: CGFloat = 55.0
        #if targetEnvironment(macCatalyst)
        height = 40.0
        #endif
        return height
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "keywordCell", for: indexPath)
        let checked = Filters.current.isKeywordSelected(keyword: keywords[indexPath.row])
        if checked {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        cell.textLabel?.text = keywords[indexPath.row]
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let type = keywords[indexPath.row]
        if Filters.current.isKeywordSelected(keyword: type){
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
            Filters.current.deselectKeyword(keyword: type)
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            Filters.current.selectKeyword(keyword: type)
        }
        filterController?.keywordLabel.text = Filters.current.getSelectedKeywordsDescription()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
