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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isfirstload = !defaults.bool(forKey: "hasopenedbefore" )
        print(isfirstload)
        if isfirstload {
            
            downloadSets()
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
                        var setCount = SetsToDownload.count
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
}

