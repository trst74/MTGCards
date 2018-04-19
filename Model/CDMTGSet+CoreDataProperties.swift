//
//  CDMTGSet+CoreDataProperties.swift
//  MTGCards
//
//  Created by Joseph Smith on 4/3/18.
//  Copyright © 2018 Robotic Snail Software. All rights reserved.
//
//

import Foundation
import CoreData


extension CDMTGSet {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDMTGSet> {
        return NSFetchRequest<CDMTGSet>(entityName: "CDMTGSet")
    }

    @NSManaged public var block: String?
    @NSManaged public var border: String?
    @NSManaged public var code: String?
    @NSManaged public var magicCardsInfoCode: String?
    @NSManaged public var mkmID: Int16
    @NSManaged public var mkmName: String?
    @NSManaged public var name: String?
    @NSManaged public var releaseDate: String?
    @NSManaged public var type: String?
    @NSManaged public var cards: NSSet?
    @NSManaged public var translations: CDTranslation?

}

// MARK: Generated accessors for cards
extension CDMTGSet {

    @objc(addCardsObject:)
    @NSManaged public func addToCards(_ value: CDCard)

    @objc(removeCardsObject:)
    @NSManaged public func removeFromCards(_ value: CDCard)

    @objc(addCards:)
    @NSManaged public func addToCards(_ values: NSSet)

    @objc(removeCards:)
    @NSManaged public func removeFromCards(_ values: NSSet)

}
