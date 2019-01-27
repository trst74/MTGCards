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
    static func getSet(setCode: String) -> Set?{
        //https://mtgjson.com/json/RNA.json
        guard let managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
            else {
                fatalError("Failed to decode Set")
        }
        print(setCode)
        let rnaURL = URL(string: "https://mtgjson.com/json/\(setCode).json")
        let data = try? Data(contentsOf: rnaURL!)
        if let d = data {
            do {
                let RNA = try newJSONDecoder().decode(Set.self, from: d)
                print(RNA.cards.count)
            } catch let error {
                print(error)
            }
            (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
        }
        return nil
    }
    static func getSetList(){
        let setListURL = URL(string: "https://mtgjson.com/json/SetList.json")
        let setList = try? SetList.init(fromURL: setListURL!)
        if let sl = setList {
            print(sl.count)
            for s in sl {
                getSet(setCode: s.code!)
            }
        }
    }
    static func getRNA() -> Set? {
        var s = getSet(setCode: "RNA")
        
        return s
    }
}
