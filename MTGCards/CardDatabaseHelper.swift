//
//  CardDatabaseHelper.swift
//  MTGCards
//
//  Created by Joseph Smith on 3/26/18.
//  Copyright © 2018 Robotic Snail Software. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CardDatabaseHelper {
    static var Sets: [MTGSet] = []
    static var CDSets: [CDMTGSet] = []
    static var SetsToDownload : [String] = []
    
    
    fileprivate let coreDataManager = CoreDataManager(modelName: "MTGCards")
    
    static func DownloadDatabase(){
        getInitialSetList()
    }
    
    static func getInitialSetList() {
        let url = URL(string: "https://mtgjson.com/json/SetCodes.json")
        let urlRequest = URLRequest(url: url!)
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest){
            (data, response, error) -> Void in
            if let data = data{
                do {
                    let JSON = try! JSONSerialization.jsonObject(with: data, options: []) as? [String]
                    
                    if let json = JSON {
                        self.SetsToDownload = json
                        print(self.SetsToDownload.count)
                        for s in self.SetsToDownload {
                            self.getSet(setCode: s)
                            //self.getCards(setCode: s)
                            
                        }
                    }
                    
                }
            } else if let error = error {
                print("Error: \(error)")
                
            }
        }
        task.resume()
        
    }
    static func getCards(setCode: String){
        DispatchQueue.main.async {
            let appDelegate: AppDelegate = (UIApplication.shared.delegate as? AppDelegate)!
            let managedContext = appDelegate.persistentContainer.viewContext
            
            let url = URL(string: "https://mtgjson.com/json/"+setCode+"-x.json")
            do {
                let set = try MTGSet.init(fromURL: url!)
                
                let cdset = CDMTGSet.init(from: set, inContext: managedContext)
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
    }
    static func getSet(setCode: String) {
        let appDelegate: AppDelegate = (UIApplication.shared.delegate as? AppDelegate)!
        let managedContext = appDelegate.persistentContainer.viewContext
        //let set = sets[0]
        let url = URL(string: "https://mtgjson.com/json/"+setCode+"-x.json")
        let urlRequest = URLRequest(url: url!)
        let session = URLSession.shared
        
        let task = session.dataTask(with: urlRequest){
            (data, response, error) -> Void in
            if let data = data{
                do {
                    
                    let set = try MTGSet(data: data)
                    print(set.code! + ":" + (set.cards?.count.description)!)
                    let cdset = CDMTGSet.init(from: set, inContext: managedContext)
                    
                    self.Sets.append(set)
                    do {
                        try cdset.managedObjectContext?.save()
                    } catch let error as NSError {
                        print("error saving set. \(error)")
                    }
                } catch let error as NSError {
                    print("error saving \(setCode). \(error)")
                }
            } else if let error = error {
                print("Error \(setCode): \(error)")
                
            }
        }
        task.resume()
    }
    static func getCDMTGSet(setCode: String) -> CDMTGSet?{
        let appDelegate: AppDelegate = (UIApplication.shared.delegate as? AppDelegate)!
        var set: CDMTGSet? = nil
        let fetchRequest: NSFetchRequest<CDMTGSet> = CDMTGSet.fetchRequest()
        let managedContext = appDelegate.persistentContainer.viewContext
        let namePredicate = NSPredicate(format: "code = %@", setCode)
        fetchRequest.predicate = namePredicate
        do {
            // Perform Fetch Request
            let c = try managedContext.fetch(fetchRequest)
            //print(c.count)
            if c.count >= 1 {
                set = c[0]
            }
            
            return set
        } catch {
            print("Unable to Fetch set, (\(error))")
            return set
        }
        
    }
    static func getCard(cardId: String) -> CDCard?{
        let appDelegate: AppDelegate = (UIApplication.shared.delegate as? AppDelegate)!
        var card: CDCard? = nil
        let fetchRequest: NSFetchRequest<CDCard> = CDCard.fetchRequest()
        let managedContext = appDelegate.persistentContainer.viewContext
        let namePredicate = NSPredicate(format: "id = %@", cardId)
        fetchRequest.predicate = namePredicate
        do {
            // Perform Fetch Request
            let c = try managedContext.fetch(fetchRequest)
            //print(c.count)
            if c.count >= 1 {
                card = c[0]
            }
            
            return card
        } catch {
            print("Unable to Fetch card, (\(error))")
            return card
        }
    }
    
}


