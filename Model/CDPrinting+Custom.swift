//
//  CDPrinting+Custom.swift
//  MTGCards
//
//  Created by Joseph Smith on 3/19/18.
//  Copyright © 2018 Robotic Snail Software. All rights reserved.
//

import Foundation
import CoreData

extension CDPrinting{
    convenience init(from source: String, inContext context: NSManagedObjectContext){
        self.init(context: context)
        self.printing = source
        
    }
}
