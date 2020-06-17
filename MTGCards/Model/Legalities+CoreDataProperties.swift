//
//  Legalities+CoreDataProperties.swift
//  MTGCards
//
//  Created by Joseph Smith on 4/13/20.
//  Copyright © 2020 Robotic Snail Software. All rights reserved.
//
//

import Foundation
import CoreData


extension Legalities {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Legalities> {
        return NSFetchRequest<Legalities>(entityName: "Legalities")
    }

    @NSManaged public var brawl: String?
    @NSManaged public var commander: String?
    @NSManaged public var duel: String?
    @NSManaged public var frontier: String?
    @NSManaged public var future: String?
    @NSManaged public var legacy: String?
    @NSManaged public var modern: String?
    @NSManaged public var pauper: String?
    @NSManaged public var penny: String?
    @NSManaged public var pioneer: String?
    @NSManaged public var standard: String?
    @NSManaged public var the1V1: String?
    @NSManaged public var vintage: String?
    @NSManaged public var card: Card?

}
