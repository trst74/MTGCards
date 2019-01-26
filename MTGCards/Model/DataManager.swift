//
//  DataManager.swift
//  MTGCards
//
//  Created by Joseph Smith on 1/17/19.
//  Copyright © 2019 Robotic Snail Software. All rights reserved.
//

import Foundation

public class DataManager {
    static func getLocalVersion() -> String {
        return "1.0"
    }
    static func getSet(setCode: String) -> Set?{
        //https://mtgjson.com/json/RNA.json
        let rnaURL = URL(string: "https://mtgjson.com/json/\(setCode).json")
        let RNA = try? Set.init(fromURL: rnaURL!)
        if let rna = RNA {
            print(rna.name! + ": " + (rna.cards?.count.description)!)
            return rna
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
