//
//  CDType+Custom.swift
//  MTGCards
//
//  Created by Joseph Smith on 3/20/18.
//  Copyright © 2018 Robotic Snail Software. All rights reserved.
//

import Foundation
import CoreData

extension CDType {
    convenience init(from source: String, inContext context: NSManagedObjectContext){
        self.init(context: context)
        self.type = source
        
    }
}
