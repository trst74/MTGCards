//
//  Collection+CoreDataProperties.swift
//  MTGCards
//
//  Created by Joseph Smith on 3/16/19.
//  Copyright © 2019 Robotic Snail Software. All rights reserved.
//
//

import Foundation
import CoreData


extension Collection {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Collection> {
        return NSFetchRequest<Collection>(entityName: "Collection")
    }

    @NSManaged public var name: String?
    @NSManaged public var cards: NSSet?

}

// MARK: Generated accessors for cards
extension Collection {

    @objc(addCardsObject:)
    @NSManaged public func addToCards(_ value: CollectionCard)

    @objc(removeCardsObject:)
    @NSManaged public func removeFromCards(_ value: CollectionCard)

    @objc(addCards:)
    @NSManaged public func addToCards(_ values: NSSet)

    @objc(removeCards:)
    @NSManaged public func removeFromCards(_ values: NSSet)

}
