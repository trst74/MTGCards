//
//  CDName+Custom.swift
//  MTGCards
//
//  Created by Joseph Smith on 3/20/18.
//  Copyright © 2018 Robotic Snail Software. All rights reserved.
//

import Foundation
import CoreData

extension CDName {
    convenience init(from source: String, inContext context: NSManagedObjectContext){
        self.init(context: context)
        self.name = source
        
    }
}
