//
//  CollectionsTableViewController.swift
//  MTGCards
//
//  Created by Joseph Smith on 3/23/18.
//  Copyright © 2018 Robotic Snail Software. All rights reserved.
//

import UIKit
import CoreData

class CollectionsTableViewController: UITableViewController {
    var sections = ["Collections", "Decks","Search"]
    // var collections = ["Cards","Wish List"]
    //var decks = ["Sliver EDH","B/R Burn","B/W Vampires","G/W Squirrel Tokens"]
    var collections: [String] = []
    var decks: [String] = []
    var search = ["Search"]
    
    let defaults:UserDefaults = UserDefaults.standard
    var isfirstload: Bool = true
    
    var detailViewController: CardsTableViewController? = nil
    var appDelegate: AppDelegate = (UIApplication.shared.delegate as? AppDelegate)!
    fileprivate let coreDataManager = CoreDataManager(modelName: "MTGCards")
    
    var progressBar = UIProgressView(progressViewStyle: UIProgressViewStyle.bar)
    var updateProgressBar = UIProgressView(progressViewStyle: UIProgressViewStyle.bar)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isfirstload = !defaults.bool(forKey: "hasopenedbefore" )
        print(isfirstload)
        if isfirstload {
            downloadSets()
        } else{
            checkForUpdates()
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func displayUpdateAlert(){
        let localVersion = defaults.string(forKey: "localVersion")
        let alert = UIAlertController(title: "Update", message: "Would you like to download Card Database Updates?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Later", style: UIAlertActionStyle.default, handler: nil))
        alert.addAction(UIAlertAction(title: "Update", style: UIAlertActionStyle.default, handler: { action in
            self.updateSets(localVersion: localVersion!)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    func checkForUpdates() {
        if var localVersion = defaults.string(forKey: "localVersion"){
            localVersion = "3.15.1"
            print("Local Version: \(localVersion)")
            let url = URL(string: "https://mtgjson.com/json/version.json")
            let urlRequest = URLRequest(url: url!)
            
            
            let config = URLSessionConfiguration.default
            config.requestCachePolicy = .reloadIgnoringLocalCacheData
            config.urlCache = nil
            
            let session = URLSession.init(configuration: config)
            let task = session.dataTask(with: urlRequest){
                (data, response, error) -> Void in
                if let data = data{
                    do {
                        if let latest = String(data: data, encoding: .utf8){
                            let latestClean = latest.replacingOccurrences(of: "\"", with: "")
                            print("Newest Version: \(latestClean)")
                            if self.compareVersions(version1: localVersion, version2: latestClean) {
                                print("There is a newer version")
                                //update
                                DispatchQueue.main.async {
                                     self.displayUpdateAlert()
                                }
                               
                                //self.updateSets(localVersion: localVersion)
                            } else {
                                print("You have the latest version")
                                //nothing
                            }
                        }
                    }
                } else if let error = error {
                    print("Error: \(error)")
                }
            }
            task.resume()
            
        }
    }
    func updateSets(localVersion: String) {
        let alert = UIAlertController(title: "Download", message: "0%", preferredStyle: UIAlertControllerStyle.alert)
        
        updateProgressBar.setProgress(0.0, animated: true)
        updateProgressBar.frame = CGRect(x: 10, y: 70, width: 250, height: 0)
        alert.view.addSubview(updateProgressBar)
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        
        
        let url = URL(string: "https://mtgjson.com/json/changelog.json")
        let urlRequest = URLRequest(url: url!)
        var managedContext: NSManagedObjectContext? = nil
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        managedContext = appDelegate.persistentContainer.viewContext
        
//        let config = URLSessionConfiguration.default
//        config.requestCachePolicy = .reloadIgnoringLocalCacheData
//        config.urlCache = nil
        
//        let session = URLSession.init(configuration: config)
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest){
            (data, response, error) -> Void in
            if let data = data{
                do {
                    var changeLogs = try ChangeLogs.init(data: data)
                    let index: Int = changeLogs.index(where: {$0.version == localVersion})!
                    var updatesToTake = Array(changeLogs[0..<index])
                    var setUpdateCount = 0
                    var setCount = 0
                    if updatesToTake.count > 0 {
                        //new
                        //if CDMTGSet does not exist add cards as normal
                        //if does exist use update function
                        for update in updatesToTake {
                            if (update.updatedSetFiles?.contains("ALL_OF_THEM"))! {
                                //update all sets
                                print("Update All")
                            } else {
                                if let updates = update.updatedSetFiles {
                                    setCount += updates.count
                                    for change in updates {
                                        //update set
                                        DispatchQueue.main.async {
                                            var set = CardDatabaseHelper.getCDMTGSet(setCode: change)
                                            if set == nil {
                                                self.getCards(setCode: change)
                                            } else {
                                                //update set data
                                                if let mtgSet = self.getMTGSet(setCode: change) {
                                                    set?.updateCDSetFromSet(source: mtgSet, inContext: managedContext!)
                                                }
                                            }
                                            setUpdateCount += 1
                                            let percent = Float(setUpdateCount)/Float(setCount)
                                            print((Float(setUpdateCount)/Float(setCount))*100)
                                            self.updateProgressBar.setProgress(percent, animated: true)
                                            alert.message = "\(Int(percent*100))%"
                                            if setUpdateCount == setCount {
                                                alert.dismiss(animated: true, completion: nil)
                                            }
                                            print(set?.name)
                                            print(change)
                                        }
                                        
                                        
                                    }
                                }
                                if let newsets = update.newSetFiles {
                                    setCount += newsets.count
                                    for new in newsets {
                                        //add set
                                      
                                    }
                                }
                                if let deletes = update.removedSetFiles {
                                    setCount += deletes.count
                                    for delete in deletes {
                                        //delete set?
                                     
                                    }
                                }
                            }
                        }
                    }
                    
                    print("updates")
                    if setUpdateCount == setCount {
                        alert.dismiss(animated: true, completion: nil)
                    }
                } catch let error as NSError {
                    print("error updating sets: \(error)")
                }
               
            } else if let error = error {
                print("Error: \(error)")
                
            }
           
        }
        task.resume()
        self.present(alert, animated: true, completion: nil)
    }
//    private func getSet(setCode: String) -> CDMTGSet?{
//        var set: CDMTGSet? = nil
//        let fetchRequest: NSFetchRequest<CDMTGSet> = CDMTGSet.fetchRequest()
//        let managedContext = appDelegate.persistentContainer.viewContext
//        let namePredicate = NSPredicate(format: "code = %@", setCode)
//        fetchRequest.predicate = namePredicate
//        do {
//            // Perform Fetch Request
//            let c = try managedContext.fetch(fetchRequest)
//            print(c.count)
//            if c.count >= 1 {
//                set = c[0]
//            }
//
//            return set
//        } catch {
//            print("Unable to Fetch set, (\(error))")
//            return set
//        }
//
//    }
    func downloadSets() {
        let alert = UIAlertController(title: "Setup", message: "Would you like to download the Card Database?", preferredStyle: UIAlertControllerStyle.alert)
        
        progressBar.setProgress(0.0, animated: true)
        progressBar.frame = CGRect(x: 10, y: 70, width: 250, height: 0)
        alert.view.addSubview(progressBar)
        alert.addAction(UIAlertAction(title: "Later", style: UIAlertActionStyle.default, handler: nil))
        alert.addAction(UIAlertAction(title: "Download", style: UIAlertActionStyle.default, handler: { action in
            self.showDownloadProgressController()
            
            self.defaults.set(true, forKey: "hasopenedbefore")
            
        }))
        //appDelegate.showAlertGlobally(alert)
        self.present(alert, animated: true, completion: nil)
    }
//    func showUpdateProgressController(setsToUpdate: [String]) {
//        let alert = UIAlertController(title: "Update", message: "Progress", preferredStyle: UIAlertControllerStyle.alert)
//
//        progressBar.setProgress(0.0, animated: true)
//        progressBar.frame = CGRect(x: 10, y: 70, width: 250, height: 0)
//        alert.view.addSubview(progressBar)
//
//        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
//        let setCount = setsToUpdate.count
//        var setDownloadCount = 0
//        for s in setsToUpdate {
//            DispatchQueue.main.sync {
//                self.getCards(setCode: s)
//                //self.getCards(setCode: s)
//                setDownloadCount += 1
//                let percent = Float(setDownloadCount)/Float(setCount)
//                print((Float(setDownloadCount)/Float(setCount))*100)
//                self.progressBar.setProgress(percent, animated: true)
//                alert.message = "\(Int(percent*100))%"
//                if setDownloadCount == setCount {
//                    alert.dismiss(animated: true, completion: nil)
//                    self.getLatestVersion()
//                }
//            }
//        }
//        self.present(alert, animated: true, completion: nil)
//    }
    func showDownloadProgressController(){
        let alert = UIAlertController(title: "Download", message: "Progress", preferredStyle: UIAlertControllerStyle.alert)
        
        progressBar.setProgress(0.0, animated: true)
        progressBar.frame = CGRect(x: 10, y: 70, width: 250, height: 0)
        alert.view.addSubview(progressBar)
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        var SetsToDownload : [String] = []
        let url = URL(string: "https://mtgjson.com/json/SetCodes.json")
        let urlRequest = URLRequest(url: url!)
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest){
            (data, response, error) -> Void in
            if let data = data{
                do {
                    let JSON = try! JSONSerialization.jsonObject(with: data, options: []) as? [String]
                    if let json = JSON {
                        SetsToDownload = json
                        print(SetsToDownload.count)
                        let setCount = SetsToDownload.count
                        var setDownloadCount = 0
                        for s in SetsToDownload {
                            DispatchQueue.main.sync {
                                self.getCards(setCode: s)
                                //self.getCards(setCode: s)
                                setDownloadCount += 1
                                let percent = Float(setDownloadCount)/Float(setCount)
                                print((Float(setDownloadCount)/Float(setCount))*100)
                                self.progressBar.setProgress(percent, animated: true)
                                alert.message = "\(Int(percent*100))%"
                                if setDownloadCount == setCount {
                                    alert.dismiss(animated: true, completion: nil)
                                    //self.getLatestVersion()
                                }
                            }
                        }
                    }
                }
            } else if let error = error {
                print("Error: \(error)")
            }
        }
        task.resume()
        self.present(alert, animated: true, completion: nil)
    }
    func getLatestVersion() -> String {
        let url = URL(string: "https://mtgjson.com/json/version.json")
        let latest = ""
        let urlRequest = URLRequest(url: url!)
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest){
            (data, response, error) -> Void in
            if let data = data{
                do {
                    if let latest = String(data: data, encoding: .utf8){
                        let latestClean = latest.replacingOccurrences(of: "\"", with: "")
                        self.defaults.set(latestClean, forKey: "localVersion")
                    }
                }
            } else if let error = error {
                print("Error: \(error)")
            }
        }
        task.resume()
        
        return latest
    }
    func getCards(setCode: String){
        var managedContext: NSManagedObjectContext? = nil
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        managedContext = appDelegate.persistentContainer.viewContext
        
        let url = URL(string: "https://mtgjson.com/json/"+setCode+"-x.json")
        do {
            let set = try MTGSet.init(fromURL: url!)
            
            let cdset = CDMTGSet.init(from: set, inContext: managedContext!)
            do {
                try cdset.managedObjectContext?.save()
                print(set.code! + ":" + (set.cards?.count.description)!)
            } catch let error as NSError {
                print("error saving \(setCode). \(error)")
            }
        } catch let error {
            print("error getting \(setCode) - \(error)")
        }
        
    }
    func getMTGSet(setCode: String) -> MTGSet? {
        let url = URL(string: "https://mtgjson.com/json/"+setCode+"-x.json")
        do {
            let set = try MTGSet.init(fromURL: url!)
            return set
           
        } catch let error {
            print("error getting \(setCode) - \(error)")
            return nil
        }
    }
    func updateCards(setCode: String) {
        var managedContext: NSManagedObjectContext? = nil
        
        
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        managedContext = appDelegate.persistentContainer.viewContext
        
        let url = URL(string: "https://mtgjson.com/json/"+setCode+"-x.json")
        do {
            let set = try MTGSet.init(fromURL: url!)
            if let existingSet = CardDatabaseHelper.getCDMTGSet(setCode: setCode) {
                existingSet.updateCDSetFromSet(source: set, inContext: managedContext!)
                do {
                    try existingSet.managedObjectContext?.save()
                    
                    print("Update " + set.code! + ":" + (set.cards?.count.description)!)
                } catch let error as NSError {
                    print("error saving \(setCode). \(error)")
                }
            }
        } catch let error {
            print("error getting \(setCode) - \(error)")
        }
    }
//    func getCard(cardId: String) -> CDCard?{
//        var card: CDCard? = nil
//        let fetchRequest: NSFetchRequest<CDCard> = CDCard.fetchRequest()
//        let managedContext = appDelegate.persistentContainer.viewContext
//        let namePredicate = NSPredicate(format: "id = %@", cardId)
//        fetchRequest.predicate = namePredicate
//        do {
//            // Perform Fetch Request
//            let c = try managedContext.fetch(fetchRequest)
//            print(c.count)
//            if c.count >= 1 {
//                card = c[0]
//            }
//
//            return card
//        } catch {
//            print("Unable to Fetch card, (\(error))")
//            return card
//        }
//    }
    @IBAction func addNewCollection(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add", message: "Collection or Deck?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Collection", style: UIAlertActionStyle.default, handler: {action in
            print("Collection")
            self.addCollection()
        }))
        alert.addAction(UIAlertAction(title: "Deck", style: UIAlertActionStyle.default, handler: { action in
            print("deck")
            self.addDeck()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    func addCollection(){
        let alert = UIAlertController(title: "Deck Name?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Deck Name"
        })
        
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { action in
            
            if let name = alert.textFields?.first?.text {
                print("Collection name: \(name)")
                self.collections.append(name)
                self.tableView.reloadData()
            }
        }))
        
        self.present(alert, animated: true)
    }
    func addDeck(){
        //alert for name
        let alert = UIAlertController(title: "Deck Name?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Deck Name"
        })
        
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { action in
            
            if let name = alert.textFields?.first?.text {
                print("Deck name: \(name)")
                self.decks.append(name)
                self.tableView.reloadData()
            }
        }))
        
        self.present(alert, animated: true)
        //add to coredata
        
        //refresh table view
    }
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        var count = 0
        switch section {
        case 0:
            count = collections.count
        case 1:
            count = decks.count
        case 2:
            count = search.count
        default:
            count = 0
        }
        return count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "collection", for: indexPath)
        var text = ""
        switch indexPath.section {
        case 0:
            text = collections[indexPath.row]
        case 1:
            text = decks[indexPath.row]
        case 2:
            text = search[indexPath.row]
        default:
            text = ""
        }
        // Configure the cell...
        cell.textLabel?.text = text
        return cell
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier != "settingsSegue" {
            
            
            var indexPath = tableView.indexPathForSelectedRow
            //let nav = segue.destination as! UINavigationController
            let destination = segue.destination as! CardsTableViewController
            destination.title = tableView.cellForRow(at: indexPath!)?.textLabel?.text
            if indexPath?.section == 2 {
                DispatchQueue.main.async {
                    destination.cardList = self.getSearchCards()
                    destination.title = "Search  (\(destination.cardList.count))"
                    destination.tableView.reloadData()
                }
            } else if indexPath?.section == 1 {
                destination.cardList = []
                //get deck
            }else if indexPath?.section == 0 {
                destination.cardList = []
                //get list
            } else {
                destination.cardList = []
            }
        }
    }
    
    private func getSearchCards() -> [CDCard]{
        var cardList: [CDCard] = []
        let fetchRequest: NSFetchRequest<CDCard> = CDCard.fetchRequest()
        let managedContext = appDelegate.persistentContainer.viewContext
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        let sortDescriptor2 = NSSortDescriptor(key: "set.name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor, sortDescriptor2]
        fetchRequest.predicate = nil
        do {
            // Perform Fetch Request
            let c = try managedContext.fetch(fetchRequest)
            print(c.count)
            cardList = c
            return cardList
        } catch {
            print("Unable to Fetch Cards, (\(error))")
            return cardList
        }
        
    }
    func compareVersions(version1: String, version2:String) -> Bool {
        let v1 = version1.split(separator: ".")
        let v2 = version2.split(separator: ".")
        if v2[0] > v1[0] {
            return true
        }
        if v2[0] == v1[0] && v2[1] > v1[1] {
            return true
        }
        if v2[0] == v1[0] && v2[1] == v1[1] && v2[2] > v1[2] {
            return true
        }
        return false
    }
}

