//
//  CDCard+CoreDataProperties.swift
//  MTGCards
//
//  Created by Joseph Smith on 4/5/18.
//  Copyright © 2018 Robotic Snail Software. All rights reserved.
//
//

import Foundation
import CoreData


extension CDCard {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDCard> {
        return NSFetchRequest<CDCard>(entityName: "CDCard")
    }

    @NSManaged public var artist: String?
    @NSManaged public var cmc: Double
    @NSManaged public var flavor: String?
    @NSManaged public var id: String?
    @NSManaged public var imageName: String?
    @NSManaged public var layout: String?
    @NSManaged public var loyalty: Int64
    @NSManaged public var manaCost: String?
    @NSManaged public var multiverseid: Int64
    @NSManaged public var name: String?
    @NSManaged public var number: String?
    @NSManaged public var originalText: String?
    @NSManaged public var originalType: String?
    @NSManaged public var power: String?
    @NSManaged public var rarity: String?
    @NSManaged public var text: String?
    @NSManaged public var toughness: String?
    @NSManaged public var type: String?
    @NSManaged public var watermark: String?
    @NSManaged public var mciNumber: String?
    @NSManaged public var colorIdentity: NSSet?
    @NSManaged public var colors: NSSet?
    @NSManaged public var foreignNames: NSSet?
    @NSManaged public var legalities: NSSet?
    @NSManaged public var names: NSSet?
    @NSManaged public var printings: NSSet?
    @NSManaged public var rulings: NSSet?
    @NSManaged public var set: CDMTGSet?
    @NSManaged public var subtypes: NSSet?
    @NSManaged public var supertypes: NSSet?
    @NSManaged public var types: NSSet?

}

// MARK: Generated accessors for colorIdentity
extension CDCard {

    @objc(addColorIdentityObject:)
    @NSManaged public func addToColorIdentity(_ value: CDColorIdentity)

    @objc(removeColorIdentityObject:)
    @NSManaged public func removeFromColorIdentity(_ value: CDColorIdentity)

    @objc(addColorIdentity:)
    @NSManaged public func addToColorIdentity(_ values: NSSet)

    @objc(removeColorIdentity:)
    @NSManaged public func removeFromColorIdentity(_ values: NSSet)

}

// MARK: Generated accessors for colors
extension CDCard {

    @objc(addColorsObject:)
    @NSManaged public func addToColors(_ value: CDColor)

    @objc(removeColorsObject:)
    @NSManaged public func removeFromColors(_ value: CDColor)

    @objc(addColors:)
    @NSManaged public func addToColors(_ values: NSSet)

    @objc(removeColors:)
    @NSManaged public func removeFromColors(_ values: NSSet)

}

// MARK: Generated accessors for foreignNames
extension CDCard {

    @objc(addForeignNamesObject:)
    @NSManaged public func addToForeignNames(_ value: CDForeignName)

    @objc(removeForeignNamesObject:)
    @NSManaged public func removeFromForeignNames(_ value: CDForeignName)

    @objc(addForeignNames:)
    @NSManaged public func addToForeignNames(_ values: NSSet)

    @objc(removeForeignNames:)
    @NSManaged public func removeFromForeignNames(_ values: NSSet)

}

// MARK: Generated accessors for legalities
extension CDCard {

    @objc(addLegalitiesObject:)
    @NSManaged public func addToLegalities(_ value: CDLegaility)

    @objc(removeLegalitiesObject:)
    @NSManaged public func removeFromLegalities(_ value: CDLegaility)

    @objc(addLegalities:)
    @NSManaged public func addToLegalities(_ values: NSSet)

    @objc(removeLegalities:)
    @NSManaged public func removeFromLegalities(_ values: NSSet)

}

// MARK: Generated accessors for names
extension CDCard {

    @objc(addNamesObject:)
    @NSManaged public func addToNames(_ value: CDName)

    @objc(removeNamesObject:)
    @NSManaged public func removeFromNames(_ value: CDName)

    @objc(addNames:)
    @NSManaged public func addToNames(_ values: NSSet)

    @objc(removeNames:)
    @NSManaged public func removeFromNames(_ values: NSSet)

}

// MARK: Generated accessors for printings
extension CDCard {

    @objc(addPrintingsObject:)
    @NSManaged public func addToPrintings(_ value: CDPrinting)

    @objc(removePrintingsObject:)
    @NSManaged public func removeFromPrintings(_ value: CDPrinting)

    @objc(addPrintings:)
    @NSManaged public func addToPrintings(_ values: NSSet)

    @objc(removePrintings:)
    @NSManaged public func removeFromPrintings(_ values: NSSet)

}

// MARK: Generated accessors for rulings
extension CDCard {

    @objc(addRulingsObject:)
    @NSManaged public func addToRulings(_ value: CDRuling)

    @objc(removeRulingsObject:)
    @NSManaged public func removeFromRulings(_ value: CDRuling)

    @objc(addRulings:)
    @NSManaged public func addToRulings(_ values: NSSet)

    @objc(removeRulings:)
    @NSManaged public func removeFromRulings(_ values: NSSet)

}

// MARK: Generated accessors for subtypes
extension CDCard {

    @objc(addSubtypesObject:)
    @NSManaged public func addToSubtypes(_ value: CDSubType)

    @objc(removeSubtypesObject:)
    @NSManaged public func removeFromSubtypes(_ value: CDSubType)

    @objc(addSubtypes:)
    @NSManaged public func addToSubtypes(_ values: NSSet)

    @objc(removeSubtypes:)
    @NSManaged public func removeFromSubtypes(_ values: NSSet)

}

// MARK: Generated accessors for supertypes
extension CDCard {

    @objc(addSupertypesObject:)
    @NSManaged public func addToSupertypes(_ value: CDSuperType)

    @objc(removeSupertypesObject:)
    @NSManaged public func removeFromSupertypes(_ value: CDSuperType)

    @objc(addSupertypes:)
    @NSManaged public func addToSupertypes(_ values: NSSet)

    @objc(removeSupertypes:)
    @NSManaged public func removeFromSupertypes(_ values: NSSet)

}

// MARK: Generated accessors for types
extension CDCard {

    @objc(addTypesObject:)
    @NSManaged public func addToTypes(_ value: CDType)

    @objc(removeTypesObject:)
    @NSManaged public func removeFromTypes(_ value: CDType)

    @objc(addTypes:)
    @NSManaged public func addToTypes(_ values: NSSet)

    @objc(removeTypes:)
    @NSManaged public func removeFromTypes(_ values: NSSet)

}
