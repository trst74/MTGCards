//
//  ViewController.swift
//  MTGCards
//
//  Created by Joseph Smith on 3/3/18.
//  Copyright © 2018 Robotic Snail Software. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    var Sets: [MTGSet] = []
    var CDSets: [CDMTGSet] = []
    var SetsToDownload : [String] = []
    
    var appDelegate: AppDelegate = (UIApplication.shared.delegate as? AppDelegate)!
    fileprivate let coreDataManager = CoreDataManager(modelName: "MTGCards")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
 
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let alert = UIAlertController(title: "Setup", message: "Would you like to download the Card Database?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Later", style: UIAlertActionStyle.default, handler: nil))
        alert.addAction(UIAlertAction(title: "Download", style: UIAlertActionStyle.default, handler: { action in
            switch action.style{
                
            case .default:
                self.getInitialSetList()
            case .cancel:
                return
            case .destructive:
                return
            }
        }))
        self.present(alert, animated: true, completion: nil)
        
        //getInitialSetList()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func getInitialSetList() {
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
                            //self.getSet(setCode: s)
                            self.getCards(setCode: s)
                            
                        }
                    }
                    
                }
            } else if let error = error {
                print("Error: \(error)")
                
            }
        }
        task.resume()
        
    }
    func getCards(setCode: String){
         let managedContext = self.appDelegate.persistentContainer.viewContext
        
        let url = URL(string: "https://mtgjson.com/json/"+setCode+"-x.json")
        do {
            let set = try MTGSet.init(fromURL: url!)
            print(set.code! + ":" + (set.cards?.count.description)!)
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
    func getSet(setCode: String) {
        let managedContext = self.appDelegate.persistentContainer.viewContext
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
    
}

