//
//  DataManager.swift
//  MTGCards
//
//  Created by Joseph Smith on 1/17/19.
//  Copyright © 2019 Robotic Snail Software. All rights reserved.
//

import Foundation
import CoreData
import UIKit

public class DataManager {
    static func getLocalVersion() -> String {
        return "1.0"
    }
    static func getSet(setCode: String, completion: @escaping (_ success: Bool) -> Void) {
      
        let setURL = URL(string: "https://mtgjson.com/json/\(setCode).json")
        let data = try? Data(contentsOf: setURL!)
        if let d = data {
            do {
                let set = try newJSONDecoder().decode(Set.self, from: d)
                print("\(setCode): \(set.cards.count)")
                completion(true)
            } catch let error {
                print(error)
                completion(false)
            }
            do {
                try CoreDataManager.init(modelName: "MTGCards").managedObjectContext.save()
            } catch {
                print(error)
            }
            
        }
    }
    static func getSetList() -> SetList? {
        let setListURL = URL(string: "https://mtgjson.com/json/SetList.json")
        let setList = try? SetList.init(fromURL: setListURL!)
        return setList
    }
    
}
