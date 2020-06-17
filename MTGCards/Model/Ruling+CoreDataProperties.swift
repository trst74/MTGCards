//
//  Ruling+CoreDataProperties.swift
//  MTGCards
//
//  Created by Joseph Smith on 4/13/20.
//  Copyright © 2020 Robotic Snail Software. All rights reserved.
//
//

import Foundation
import CoreData


extension Ruling {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Ruling> {
        return NSFetchRequest<Ruling>(entityName: "Ruling")
    }

    @NSManaged public var date: String?
    @NSManaged var text: String?
    @NSManaged var card: Card?

}
