//
//  MTGSet+CoreDataProperties.swift
//  MTGCards
//
//  Created by Joseph Smith on 4/13/20.
//  Copyright © 2020 Robotic Snail Software. All rights reserved.
//
//

import Foundation
import CoreData


extension MTGSet {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MTGSet> {
        return NSFetchRequest<MTGSet>(entityName: "MTGSet")
    }

    @NSManaged public var baseSetSize: Int16
    @NSManaged public var block: String?
    @NSManaged public var code: String?
    @NSManaged public var isFoilOnly: Bool
    @NSManaged public var isOnlineOnly: Bool
    @NSManaged public var mtgoCode: String?
    @NSManaged public var name: String?
    @NSManaged public var releaseDate: String?
    @NSManaged public var tcgplayerGroupID: Int16
    @NSManaged public var totalSetSize: Int16
    @NSManaged public var type: String?
    @NSManaged public var cards: NSSet?
    @NSManaged public var meta: Meta?
    @NSManaged public var tokens: NSSet?

}

// MARK: Generated accessors for cards
extension MTGSet {

    @objc(addCardsObject:)
    @NSManaged public func addToCards(_ value: Card)

    @objc(removeCardsObject:)
    @NSManaged public func removeFromCards(_ value: Card)

    @objc(addCards:)
    @NSManaged public func addToCards(_ values: NSSet)

    @objc(removeCards:)
    @NSManaged public func removeFromCards(_ values: NSSet)

}

// MARK: Generated accessors for tokens
extension MTGSet {

    @objc(addTokensObject:)
    @NSManaged public func addToTokens(_ value: Token)

    @objc(removeTokensObject:)
    @NSManaged public func removeFromTokens(_ value: Token)

    @objc(addTokens:)
    @NSManaged public func addToTokens(_ values: NSSet)

    @objc(removeTokens:)
    @NSManaged public func removeFromTokens(_ values: NSSet)

}
