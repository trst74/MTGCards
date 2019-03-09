//
//  CollectionsTableViewController.swift
//  MTGCards
//
//  Created by Joseph Smith on 1/16/19.
//  Copyright © 2019 Robotic Snail Software. All rights reserved.
//

import UIKit

class CollectionsTableViewController: UITableViewController {
  var stateCoordinator: StateCoordinator?
    var collections = ["Collections", "Collection", "Wish List"]
    var decks = ["Decks", "Sliver EDH", "Knights", "Green Stompy"]
    var search = ["Search", "Search"]
    var sections: [[String]] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addButton)), animated: true)
        let settingsButton = UIBarButtonItem(image: UIImage(named: "settings"), style: .plain, target: self, action: #selector(self.settings))
        self.navigationItem.setLeftBarButton(settingsButton, animated: true)
        sections = [collections, decks, search]
    }
    @objc func addButton() {
        print("add button clicked")
    }
    @objc func settings(){
        print("settings")
        let storyboard = UIStoryboard(name: "Settings", bundle: nil)
        guard let settingsVC = storyboard.instantiateInitialViewController() as? SettingsTableViewController else {
            fatalError("Error going to settings")
        }
        //self.navigationController?.pushViewController(settingsVC, animated: true)
        self.present(settingsVC, animated: true, completion: nil)
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sections[section].count - 1
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section][0]
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "collectionCell", for: indexPath)
        cell.textLabel?.text = sections[indexPath.section][indexPath.row + 1]
        // Configure the cell...

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        StateCoordinator.shared.didSelectCollection(collection: "Search")
    }
}
extension CollectionsTableViewController {
    static func freshCollectionsList() -> CollectionsTableViewController {
        let storyboard = UIStoryboard(name: "Collections", bundle: nil)
        guard let filelist = storyboard.instantiateInitialViewController() as? CollectionsTableViewController else {
            fatalError("Project config error - storyboard doesnt provide a FileListVC")
        }
        return filelist
    }
}
