//
//  Deck+CoreDataProperties.swift
//  MTGCards
//
//  Created by Joseph Smith on 4/10/20.
//  Copyright © 2020 Robotic Snail Software. All rights reserved.
//
//

import Foundation
import CoreData


extension Deck {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Deck> {
        return NSFetchRequest<Deck>(entityName: "Deck")
    }

    @NSManaged public var format: String?
    @NSManaged public var name: String?
    @NSManaged public var cards: NSSet?

}

// MARK: Generated accessors for cards
extension Deck {

    @objc(addCardsObject:)
    @NSManaged public func addToCards(_ value: DeckCard)

    @objc(removeCardsObject:)
    @NSManaged public func removeFromCards(_ value: DeckCard)

    @objc(addCards:)
    @NSManaged public func addToCards(_ values: NSSet)

    @objc(removeCards:)
    @NSManaged public func removeFromCards(_ values: NSSet)

}
