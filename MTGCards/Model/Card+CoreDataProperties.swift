//
//  Card+CoreDataProperties.swift
//  MTGCards
//
//  Created by Joseph Smith on 4/13/20.
//  Copyright © 2020 Robotic Snail Software. All rights reserved.
//
//

import Foundation
import CoreData


extension Card {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Card> {
        return NSFetchRequest<Card>(entityName: "Card")
    }

    @NSManaged public var artist: String?
    @NSManaged public var borderColor: String?
    @NSManaged public var colors: NSObject?
    @NSManaged public var convertedManaCost: Float
    @NSManaged public var faceConvertedManaCost: Float
    @NSManaged public var flavorText: String?
    @NSManaged public var frameVersion: String?
    @NSManaged public var hasFoil: Bool
    @NSManaged public var hasNonFoil: Bool
    @NSManaged public var isReserved: Bool
    @NSManaged public var layout: String?
    @NSManaged public var loyalty: String?
    @NSManaged public var manaCost: String?
    @NSManaged public var multiverseID: Int32
    @NSManaged public var name: String?
    @NSManaged public var names: NSObject?
    @NSManaged public var number: String?
    @NSManaged public var originalText: String?
    @NSManaged public var originalType: String?
    @NSManaged public var power: String?
    @NSManaged public var printings: NSObject?
    @NSManaged public var rarity: String?
    @NSManaged public var scryfallID: String?
    @NSManaged public var side: String?
    @NSManaged public var starter: Bool
    @NSManaged public var stringsupertypes: NSObject?
    @NSManaged public var tcgplayerProductID: Int32
    @NSManaged public var tcgplayerPurchaseURL: String?
    @NSManaged public var text: String?
    @NSManaged public var toughness: String?
    @NSManaged public var type: String?
    @NSManaged public var uuid: String?
    @NSManaged public var variations: NSObject?
    @NSManaged public var watermark: String?
    @NSManaged public var cardsubtypes: NSSet?
    @NSManaged public var cardsupertypes: NSSet?
    @NSManaged public var colorIdentity: NSSet?
    @NSManaged public var foreignData: NSSet?
    @NSManaged public var legalities: Legalities?
    @NSManaged public var rulings: NSSet?
    @NSManaged public var set: MTGSet?
    @NSManaged public var types: NSSet?
    @NSManaged public var decks: DeckCard?
    @NSManaged public var collections: CollectionCard?

}

// MARK: Generated accessors for cardsubtypes
extension Card {

    @objc(addCardsubtypesObject:)
    @NSManaged public func addToCardsubtypes(_ value: CardSubtype)

    @objc(removeCardsubtypesObject:)
    @NSManaged public func removeFromCardsubtypes(_ value: CardSubtype)

    @objc(addCardsubtypes:)
    @NSManaged public func addToCardsubtypes(_ values: NSSet)

    @objc(removeCardsubtypes:)
    @NSManaged public func removeFromCardsubtypes(_ values: NSSet)

}

// MARK: Generated accessors for cardsupertypes
extension Card {

    @objc(addCardsupertypesObject:)
    @NSManaged public func addToCardsupertypes(_ value: CardSupertype)

    @objc(removeCardsupertypesObject:)
    @NSManaged public func removeFromCardsupertypes(_ value: CardSupertype)

    @objc(addCardsupertypes:)
    @NSManaged public func addToCardsupertypes(_ values: NSSet)

    @objc(removeCardsupertypes:)
    @NSManaged public func removeFromCardsupertypes(_ values: NSSet)

}

// MARK: Generated accessors for colorIdentity
extension Card {

    @objc(addColorIdentityObject:)
    @NSManaged public func addToColorIdentity(_ value: ColorIdentity)

    @objc(removeColorIdentityObject:)
    @NSManaged public func removeFromColorIdentity(_ value: ColorIdentity)

    @objc(addColorIdentity:)
    @NSManaged public func addToColorIdentity(_ values: NSSet)

    @objc(removeColorIdentity:)
    @NSManaged public func removeFromColorIdentity(_ values: NSSet)

}

// MARK: Generated accessors for foreignData
extension Card {

    @objc(addForeignDataObject:)
    @NSManaged public func addToForeignData(_ value: ForeignDatum)

    @objc(removeForeignDataObject:)
    @NSManaged public func removeFromForeignData(_ value: ForeignDatum)

    @objc(addForeignData:)
    @NSManaged public func addToForeignData(_ values: NSSet)

    @objc(removeForeignData:)
    @NSManaged public func removeFromForeignData(_ values: NSSet)

}

// MARK: Generated accessors for rulings
extension Card {

    @objc(addRulingsObject:)
    @NSManaged public func addToRulings(_ value: Ruling)

    @objc(removeRulingsObject:)
    @NSManaged public func removeFromRulings(_ value: Ruling)

    @objc(addRulings:)
    @NSManaged public func addToRulings(_ values: NSSet)

    @objc(removeRulings:)
    @NSManaged public func removeFromRulings(_ values: NSSet)

}

// MARK: Generated accessors for types
extension Card {

    @objc(addTypesObject:)
    @NSManaged public func addToTypes(_ value: CardType)

    @objc(removeTypesObject:)
    @NSManaged public func removeFromTypes(_ value: CardType)

    @objc(addTypes:)
    @NSManaged public func addToTypes(_ values: NSSet)

    @objc(removeTypes:)
    @NSManaged public func removeFromTypes(_ values: NSSet)

}
