//
//  CDRuling+Custom.swift
//  MTGCards
//
//  Created by Joseph Smith on 3/19/18.
//  Copyright © 2018 Robotic Snail Software. All rights reserved.
//

import Foundation
import CoreData

extension CDRuling{
    convenience init(from source: Ruling, inContext context: NSManagedObjectContext){
        self.init(context: context)
        self.text = source.text
        if let d = source.date?.toDate(dateFormat: "yyyy-MM-dd") {
            self.date = d
        }
        
    }
}
