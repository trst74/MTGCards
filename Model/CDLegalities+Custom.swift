//
//  CDLegalities+Custom.swift
//  MTGCards
//
//  Created by Joseph Smith on 3/20/18.
//  Copyright © 2018 Robotic Snail Software. All rights reserved.
//

import Foundation
import CoreData

extension CDLegaility {
    convenience init(from source: Legality, inContext context: NSManagedObjectContext){
        self.init(context: context)
        self.format = source.format
        self.legality = source.legality
        
    }
}
