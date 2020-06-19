//
//  Card.swift
//  MTGCards
//
//  Created by Joseph Smith on 1/26/19.
//  Copyright © 2019 Robotic Snail Software. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Card: NSManagedObject, Codable {
    @NSManaged var artist: String?
    @NSManaged var borderColor: String?
    private var stringColorIdentity: [String]?
    @NSManaged var colors: [String]?
    @NSManaged var convertedManaCost: Float
    @NSManaged var flavorText: String?
    @NSManaged var foreignData: NSSet
    @NSManaged var frameVersion: String?
    @NSManaged var hasFoil: Bool
    @NSManaged var hasNonFoil: Bool
    @NSManaged var layout: String?
    @NSManaged var legalities: Legalities?
    @NSManaged var manaCost: String?
    @NSManaged var multiverseID: Int32
    @NSManaged var name: String?
    @NSManaged var number: String?
    @NSManaged var originalText: String?
    @NSManaged var originalType: String?
    @NSManaged var power: String?
    @NSManaged var printings: [String]?
    @NSManaged var rarity: String?
    @NSManaged var rulings: NSSet
    @NSManaged var scryfallID: String?
    private var stringsubtypes: [String]?
    @NSManaged var stringsupertypes: [String]?
    @NSManaged var tcgplayerProductID: Int32
    @NSManaged var tcgplayerPurchaseURL: String?
    @NSManaged var text: String?
    @NSManaged var toughness: String?
    @NSManaged var type: String?
    private var stringTypes: [String]?
    @NSManaged var uuid: String?
    @NSManaged var watermark: String?
    @NSManaged var names: [String]?
    @NSManaged var loyalty: String?
    @NSManaged var faceConvertedManaCost: Float
    @NSManaged var side: String?
    @NSManaged var variations: [String]?
    @NSManaged var starter: Bool
    @NSManaged var set: MTGSet
    @NSManaged var isReserved: Bool
    @NSManaged var types: NSSet?
    @NSManaged var colorIdentity: NSSet?
    @NSManaged var cardsubtypes: NSSet?
    @NSManaged public var cardsupertypes: NSSet?
    private var identifiers: CardIdentifiers?
    private var keywordStrings: [String]?
    @NSManaged var keywords: NSSet?
    
    enum CodingKeys: String, CodingKey {
        case artist = "artist"
        case borderColor = "borderColor"
        case stringColorIdentity = "colorIdentity"
        case colors = "colors"
        case convertedManaCost = "convertedManaCost"
        case flavorText = "flavorText"
        case foreignData = "foreignData"
        case frameVersion = "frameVersion"
        case hasFoil = "hasFoil"
        case hasNonFoil = "hasNonFoil"
        case layout = "layout"
        case legalities = "legalities"
        case manaCost = "manaCost"
        case multiverseID = "multiverseId"
        case name = "name"
        case number = "number"
        case originalText = "originalText"
        case originalType = "originalType"
        case power = "power"
        case printings = "printings"
        case rarity = "rarity"
        case rulings = "rulings"
        case scryfallID = "scryfallId"
        case stringsubtypes = "subtypes"
        case stringsupertypes = "supertypes"
        case tcgplayerProductID = "tcgplayerProductId"
        case tcgplayerPurchaseURL = "tcgplayerPurchaseUrl"
        case text = "text"
        case toughness = "toughness"
        case type = "type"
        case stringTypes = "types"
        case uuid = "uuid"
        case watermark = "watermark"
        case names = "names"
        case loyalty = "loyalty"
        case faceConvertedManaCost = "faceConvertedManaCost"
        case side = "side"
        case variations = "variations"
        case starter = "starter"
        case isReserved = "isReserved"
        case identifiers = "identifiers"
        case keywordStrings = "keywords"
    }
    
    required convenience init(from decoder: Decoder) throws {
        //        let managedObjectContext = CoreDataStack.handler.privateContext
        //        guard  let entity = NSEntityDescription.entity(forEntityName: "Card", in: managedObjectContext) else {
        //            fatalError("Failed to decode Card")
        //        }
        guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext,
            let managedObjectContext = decoder.userInfo[codingUserInfoKeyManagedObjectContext] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "Card", in: managedObjectContext) else {
                fatalError("Failed to decode User")
        }
        self.init(entity: entity, insertInto: managedObjectContext)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.identifiers = try container.decodeIfPresent(CardIdentifiers.self, forKey: .identifiers)
        self.artist = try container.decodeIfPresent(String.self, forKey: .artist)
        self.borderColor = try container.decodeIfPresent(String.self, forKey: .borderColor)
        self.stringColorIdentity = try container.decodeIfPresent([String].self, forKey: .stringColorIdentity)
        for i in self.stringColorIdentity ?? []{
            guard  let entity = NSEntityDescription.entity(forEntityName: "ColorIdentity", in: managedObjectContext) else {
                fatalError("Failed to decode Card")
            }
            let tempColor = ColorIdentity.init(entity: entity, insertInto: managedObjectContext)
            tempColor.color = i
            tempColor.card = self
            self.addToColorIdentity(tempColor)
        }
        self.colors = try container.decodeIfPresent([String].self, forKey: .colors)
        if let cmc = try container.decodeIfPresent(Float.self, forKey: .convertedManaCost) {
            self.convertedManaCost = cmc
        }
        self.flavorText = try container.decodeIfPresent(String.self, forKey: .flavorText)
        if let fd = try container.decodeIfPresent([ForeignDatum].self, forKey: .foreignData) {
            if fd.count > 0 {
                for datum in fd {
                    datum.card = self
                }
                self.foreignData.addingObjects(from: fd)
            }
        }
        self.frameVersion = try container.decodeIfPresent(String.self, forKey: .frameVersion)
        self.hasFoil = try container.decodeIfPresent(Bool.self, forKey: .hasFoil)!
        self.hasNonFoil = try container.decodeIfPresent(Bool.self, forKey: .hasNonFoil)!
        self.layout = try container.decodeIfPresent(String.self, forKey: .layout)
        self.legalities = try container.decodeIfPresent(Legalities.self, forKey: .legalities)
        self.manaCost = try container.decodeIfPresent(String.self, forKey: .manaCost)
        
        self.multiverseID = Int32(identifiers?.multiverseID ?? "") ?? 0
        
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.number = try container.decodeIfPresent(String.self, forKey: .number)
        self.originalText = try container.decodeIfPresent(String.self, forKey: .originalText)
        self.originalType = try container.decodeIfPresent(String.self, forKey: .originalType)
        self.power = try container.decodeIfPresent(String.self, forKey: .power)
        self.printings = try container.decodeIfPresent([String].self, forKey: .printings)
        self.rarity = try container.decodeIfPresent(String.self, forKey: .rarity)
        if let tempRulings = try container.decodeIfPresent([Ruling].self, forKey: .rulings) {
            if tempRulings.count > 0 {
                for ruling in tempRulings {
                    ruling.card = self
                }
                self.rulings.addingObjects(from: tempRulings)
            }
        }
        self.scryfallID = identifiers?.scryfallID
        self.stringsubtypes = try container.decodeIfPresent([String].self, forKey: .stringsubtypes)
        for sub in stringsubtypes ?? [] {
            guard  let entity = NSEntityDescription.entity(forEntityName: "CardSubtype", in: managedObjectContext) else {
                fatalError("Failed to decode Card")
            }
            let tempsub = CardSubtype.init(entity: entity, insertInto: managedObjectContext)
            tempsub.subtype = sub
            tempsub.card = self
            self.addToCardsubtypes(tempsub)
        }
        self.stringsupertypes = try container.decodeIfPresent([String].self, forKey: .stringsupertypes)
        for sub in stringsupertypes ?? [] {
            guard  let entity = NSEntityDescription.entity(forEntityName: "CardSupertype", in: managedObjectContext) else {
                fatalError("Failed to decode Card")
            }
            let tempsub = CardSupertype.init(entity: entity, insertInto: managedObjectContext)
            tempsub.supertype = sub
            tempsub.card = self
            self.addToCardsupertypes(tempsub)
        }
        
        self.tcgplayerProductID = Int32(identifiers?.tcgplayerProductID ?? "") ?? 0
        
        self.tcgplayerPurchaseURL = try container.decodeIfPresent(String.self, forKey: .tcgplayerPurchaseURL)
        self.text = try container.decodeIfPresent(String.self, forKey: .text)
        self.toughness = try container.decodeIfPresent(String.self, forKey: .toughness)
        self.type = try container.decodeIfPresent(String.self, forKey: .type)
        self.stringTypes = try container.decodeIfPresent([String].self, forKey: .stringTypes)
        for t in self.stringTypes ?? []{
            guard  let entity = NSEntityDescription.entity(forEntityName: "CardType", in: managedObjectContext) else {
                fatalError("Failed to decode Card")
            }
            let tempType = CardType.init(entity: entity, insertInto: managedObjectContext)
            tempType.type = t
            tempType.card = self
            self.addToTypes(tempType)
        }
        self.uuid = try container.decodeIfPresent(String.self, forKey: .uuid)
        self.watermark = try container.decodeIfPresent(String.self, forKey: .watermark)
        self.names = try container.decodeIfPresent([String].self, forKey: .names)
        self.loyalty = try container.decodeIfPresent(String.self, forKey: .loyalty)
        if let face =  try container.decodeIfPresent(Float.self, forKey: .faceConvertedManaCost) {
            self.faceConvertedManaCost = face
        }
        self.side = try container.decodeIfPresent(String.self, forKey: .side)
        self.variations = try container.decodeIfPresent([String].self, forKey: .variations)
        if let starter = try container.decodeIfPresent(Bool.self, forKey: .starter) {
            self.starter = starter
        }
        if let reserved = try container.decodeIfPresent(Bool.self, forKey: .isReserved) {
            self.isReserved = reserved
        } else {
            self.isReserved = false
        }
        self.keywordStrings = try container.decodeIfPresent([String].self, forKey: .keywordStrings)
        for k in self.keywordStrings ?? [] {
            guard let entity = NSEntityDescription.entity(forEntityName: "CardKeyword", in: managedObjectContext) else {
                fatalError("Failed to decode Card")
            }
            let tempKeyword = CardKeyword.init(entity: entity, insertInto: managedObjectContext)
            tempKeyword.keyword = k
            self.addToKeywords(tempKeyword)
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(artist, forKey: .artist)
        try container.encode(borderColor, forKey: .borderColor)
        try container.encode(stringColorIdentity, forKey: .stringColorIdentity)
        try container.encode(colors, forKey: .colors)
        try container.encode(convertedManaCost, forKey: .convertedManaCost)
        try container.encode(flavorText, forKey: .flavorText)
        if let foreignDataObjects = foreignData.allObjects as? [ForeignDatum] {
            try container.encode(foreignDataObjects, forKey: .foreignData)
        }
        try container.encode(frameVersion, forKey: .frameVersion)
        try container.encode(hasFoil, forKey: .hasFoil)
        try container.encode(hasNonFoil, forKey: .hasNonFoil)
        try container.encode(layout, forKey: .layout)
        try container.encode(legalities, forKey: .legalities)
        try container.encode(manaCost, forKey: .manaCost)
        try container.encode(multiverseID, forKey: .multiverseID)
        try container.encode(name, forKey: .name)
        try container.encode(number, forKey: .number)
        try container.encode(originalText, forKey: .originalText)
        try container.encode(originalType, forKey: .originalType)
        try container.encode(power, forKey: .power)
        try container.encode(printings, forKey: .printings)
        try container.encode(rarity, forKey: .rarity)
        if let rulingObjects = rulings.allObjects as? [Ruling] {
            try container.encode(rulingObjects, forKey: .rulings)
        }
        try container.encode(scryfallID, forKey: .scryfallID)
        try container.encode(stringsubtypes, forKey: .stringsubtypes)
        try container.encode(stringsupertypes, forKey: .stringsupertypes)
        try container.encode(tcgplayerProductID, forKey: .tcgplayerProductID)
        try container.encode(tcgplayerPurchaseURL, forKey: .tcgplayerPurchaseURL)
        try container.encode(text, forKey: .text)
        try container.encode(toughness, forKey: .toughness)
        try container.encode(type, forKey: .type)
        try container.encode(stringTypes, forKey: .stringTypes)
        try container.encode(uuid, forKey: .uuid)
        try container.encode(watermark, forKey: .watermark)
        try container.encode(names, forKey: .names)
        try container.encode(loyalty, forKey: .loyalty)
        try container.encode(faceConvertedManaCost, forKey: .faceConvertedManaCost)
        try container.encode(side, forKey: .side)
        try container.encode(variations, forKey: .variations)
        try container.encode(starter, forKey: .starter)
        
    }
    
}
extension Card {
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
    
}


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

// MARK: Generated accessors for keywords
extension Card {

    @objc(addKeywordsObject:)
    @NSManaged public func addToKeywords(_ value: CardKeyword)

    @objc(removeKeywordsObject:)
    @NSManaged public func removeFromKeywords(_ value: CardKeyword)

    @objc(addKeywords:)
    @NSManaged public func addToKeywords(_ values: NSSet)

    @objc(removeKeywords:)
    @NSManaged public func removeFromKeywords(_ values: NSSet)

}
