//
//  CDDeck+CoreDataProperties.swift
//  MTGCards
//
//  Created by Joseph Smith on 4/3/18.
//  Copyright © 2018 Robotic Snail Software. All rights reserved.
//
//

import Foundation
import CoreData


extension CDDeck {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDDeck> {
        return NSFetchRequest<CDDeck>(entityName: "CDDeck")
    }

    @NSManaged public var name: String?
    @NSManaged public var cards: NSSet?

}

// MARK: Generated accessors for cards
extension CDDeck {

    @objc(addCardsObject:)
    @NSManaged public func addToCards(_ value: CDCard)

    @objc(removeCardsObject:)
    @NSManaged public func removeFromCards(_ value: CDCard)

    @objc(addCards:)
    @NSManaged public func addToCards(_ values: NSSet)

    @objc(removeCards:)
    @NSManaged public func removeFromCards(_ values: NSSet)

}
