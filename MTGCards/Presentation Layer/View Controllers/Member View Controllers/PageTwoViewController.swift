//
//  PageTwoViewController.swift
//  MTGCards
//
//  Created by Joseph Smith on 3/9/19.
//  Copyright © 2019 Robotic Snail Software. All rights reserved.
//

import UIKit
import CoreData
import CoreServices
import CoreSpotlight

class PageTwoViewController: UIViewController {
    @IBOutlet weak var downloadLabel: UILabel!
    @IBOutlet weak var downloadProgress: UIProgressView!
    @IBOutlet weak var doneButton: RoundButton!
    @IBOutlet weak var downloadButton: RoundButton!
    
    var pageOne: PageOneViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func downloadData(_ sender: Any) {
        
        
        downloadSets()
    }
    @IBAction func done(_ sender: Any) {
        
        self.dismiss(animated: true){
            self.pageOne?.dismiss(animated: false, completion: nil)
        }
    }
    func downloadSets(){
        self.downloadLabel.isHidden = false
        self.downloadProgress.isHidden = false
        self.doneButton.isEnabled = false
        self.downloadButton.isEnabled = false
        let setlist = DataManager.getSetList()
        if let sl = setlist {
            print(sl.count)
            let setTotal = sl.count
            var completed = 0
            var failed = SetList()
            var doubleFailed = SetList()
            DispatchQueue.global(qos: .default).async {
                    for s in sl {
                        DataManager.getSet(setCode: s.code) { success in
                            DispatchQueue.main.async {
                                if success {
                                    //save
                                    completed += 1
                                    let percent = Float(completed)/Float(setTotal)
                                    print("\(Int(percent*100))%")
                                    self.downloadProgress.setProgress(percent, animated: true)
                                    self.downloadLabel.text = "\(Int(percent*100))%"
                                    if completed == setTotal {
                                        self.doneButton.isEnabled = true
                                        self.downloadLabel.text = "Done!"
                                        CoreDataStack.handler.privateContext.parent?.reset()
                                        CoreDataStack.handler.privateContext.reset()
                                    }
                                } else {
                                    failed.append(s)
                                }
                            }
                        }
                    }
   
                if failed.count > 0 {
                    for fs in failed {
                        DataManager.getSet(setCode: fs.code) { success in
                            DispatchQueue.main.async {
                                if success {
                                    //save
                                    completed += 1
                                    let percent = Float(completed)/Float(setTotal)
                                    print("\(Int(percent*100))%")
                                    self.downloadProgress.setProgress(percent, animated: true)
                                    self.downloadLabel.text = "\(Int(percent*100))%"
                                    if completed == setTotal {
                                        self.doneButton.isEnabled = true
                                        self.downloadLabel.text = "Done!"
                                    }
                                } else {
                                    doubleFailed.append(fs)
                                }
                            }
                        }
                    }
                }
                DispatchQueue.main.async {
                    if doubleFailed.count > 0 {
                        let message = doubleFailed.compactMap { $0.code }.joined(separator: ", ")
                        let alert = UIAlertController(title: "One or more sets failed downloading.", message: "\(doubleFailed.count) sets failed. \(message). Please manually update from the settings screen.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                        self.doneButton.isEnabled = true
                        self.downloadLabel.text = "Done!"
                        self.present(alert, animated: true)
                    }
                    DispatchQueue.global(qos: .background).async {
                        var items: [CSSearchableItem] = []
                        let request = NSFetchRequest<Card>(entityName: "Card")
                        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
                        request.sortDescriptors = [sortDescriptor]
                        do {
                            let results = try CoreDataStack.handler.managedObjectContext.fetch(request)
                            for card in results {
                                if let card = card as? Card, let uuid = card.uuid {
                                    let attributeSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeData as String)
                                    attributeSet.title = card.name
                                    attributeSet.contentDescription = card.set.name
                                    
                                    
                                    let item = CSSearchableItem(uniqueIdentifier: "\(uuid)", domainIdentifier: "com.roboticsnailsoftware.MTGCollection", attributeSet: attributeSet)
                                    print("item created \(card.name)")
                                    items.append(item)
                                    //                        CSSearchableIndex.default().deleteSearchableItems(withIdentifiers: ["\(uuid)"]) { error in
                                    //                            if let error = error {
                                    //                                print("Deindexing error: \(error.localizedDescription)")
                                    //                            } else {
                                    //                                print("Search item successfully removed! \(card.name) \(card.set.name)")
                                    //                            }
                                    //                        }
                                }
                            }
                            if items.count > 30000 {
                                let itemsToAdd = Array(items[0...30000])
                                CSSearchableIndex.default().indexSearchableItems(itemsToAdd) { error in
                                    if let error = error {
                                        print("Indexing error: \(error.localizedDescription)")
                                    } else {
                                        print("Search item successfully indexed!")
                                    }
                                }
                                let secondItems = Array(items[30001..<items.count])
                                CSSearchableIndex.default().indexSearchableItems(secondItems) { error in
                                    if let error = error {
                                        print("Indexing error: \(error.localizedDescription)")
                                    } else {
                                        print("Search item successfully indexed!")
                                    }
                                }
                            } else {
                                CSSearchableIndex.default().indexSearchableItems(items) { error in
                                    if let error = error {
                                        print("Indexing error: \(error.localizedDescription)")
                                    } else {
                                        print("Search item successfully indexed!")
                                    }
                                }
                            }
                        } catch {
                            print(error)
                        }
                        
                        
                    }
                }
            }
        }
    }
}

