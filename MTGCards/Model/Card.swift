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
    @NSManaged var colorIdentity: [String]?
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
    @NSManaged var subtypes: [String]?
    @NSManaged var supertypes: [String]?
    @NSManaged var tcgplayerProductID: Int32
    @NSManaged var tcgplayerPurchaseURL: String?
    @NSManaged var text: String?
    @NSManaged var toughness: String?
    @NSManaged var type: String?
    @NSManaged var types: [String]?
    @NSManaged var uuid: String?
    @NSManaged var watermark: String?
    @NSManaged var names: [String]?
    @NSManaged var loyalty: String?
    @NSManaged var faceConvertedManaCost: Float
    @NSManaged var side: String?
    @NSManaged var variations: [String]?
    @NSManaged var starter: Bool
    @NSManaged var set: Set
    
    enum CodingKeys: String, CodingKey {
        case artist = "artist"
        case borderColor = "borderColor"
        case colorIdentity = "colorIdentity"
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
        case subtypes = "subtypes"
        case supertypes = "supertypes"
        case tcgplayerProductID = "tcgplayerProductId"
        case tcgplayerPurchaseURL = "tcgplayerPurchaseUrl"
        case text = "text"
        case toughness = "toughness"
        case type = "type"
        case types = "types"
        case uuid = "uuid"
        case watermark = "watermark"
        case names = "names"
        case loyalty = "loyalty"
        case faceConvertedManaCost = "faceConvertedManaCost"
        case side = "side"
        case variations = "variations"
        case starter = "starter"
    }
    
    required convenience init(from decoder: Decoder) throws {
        guard let managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext,
            let entity = NSEntityDescription.entity(forEntityName: "Card", in: managedObjectContext) else {
                fatalError("Failed to decode Card")
        }
        
        self.init(entity: entity, insertInto: managedObjectContext)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.artist = try container.decodeIfPresent(String.self, forKey: .artist)
        self.borderColor = try container.decodeIfPresent(String.self, forKey: .borderColor)
        self.colorIdentity = try container.decodeIfPresent([String].self, forKey: .colorIdentity)
        self.colors = try container.decodeIfPresent([String].self, forKey: .colors)
        if let cmc = try container.decodeIfPresent(Float.self, forKey: .convertedManaCost) {
                    self.convertedManaCost = cmc
        }
        self.flavorText = try container.decodeIfPresent(String.self, forKey: .flavorText)
        if let fd = try container.decodeIfPresent([ForeignDatum].self, forKey: .foreignData){
            if fd.count > 0 {
                self.foreignData.addingObjects(from: fd)
            }
        }
        self.frameVersion = try container.decodeIfPresent(String.self, forKey: .frameVersion)
        self.hasFoil = try container.decodeIfPresent(Bool.self, forKey: .hasFoil)!
        self.hasNonFoil = try container.decodeIfPresent(Bool.self, forKey: .hasNonFoil)!
        self.layout = try container.decodeIfPresent(String.self, forKey: .layout)
        self.legalities = try container.decodeIfPresent(Legalities.self, forKey: .legalities)
        self.manaCost = try container.decodeIfPresent(String.self, forKey: .manaCost)
        if let mvid = try container.decodeIfPresent(Int32.self, forKey: .multiverseID) {
            self.multiverseID = mvid
        }
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.number = try container.decodeIfPresent(String.self, forKey: .number)
        self.originalText = try container.decodeIfPresent(String.self, forKey: .originalText)
        self.originalType = try container.decodeIfPresent(String.self, forKey: .originalType)
        self.power = try container.decodeIfPresent(String.self, forKey: .power)
        self.printings = try container.decodeIfPresent([String].self, forKey: .printings)
        self.rarity = try container.decodeIfPresent(String.self, forKey: .rarity)
        if let rulings = try container.decodeIfPresent([Ruling].self, forKey: .rulings) {
            if rulings.count > 0 {
                self.rulings.addingObjects(from: rulings)
            }
        }
        self.scryfallID = try container.decodeIfPresent(String.self, forKey: .scryfallID)
        self.subtypes = try container.decodeIfPresent([String].self, forKey: .subtypes)
        self.supertypes = try container.decodeIfPresent([String].self, forKey: .supertypes)
        if let tcgpID = try container.decodeIfPresent(Int32.self, forKey: .tcgplayerProductID) {
            self.tcgplayerProductID = tcgpID
        }
        self.tcgplayerPurchaseURL = try container.decodeIfPresent(String.self, forKey: .tcgplayerPurchaseURL)
        self.text = try container.decodeIfPresent(String.self, forKey: .text)
        self.toughness = try container.decodeIfPresent(String.self, forKey: .toughness)
        self.type = try container.decodeIfPresent(String.self, forKey: .type)
        self.types = try container.decodeIfPresent([String].self, forKey: .types)
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
        
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(artist, forKey: .artist)
        try container.encode(borderColor, forKey: .borderColor)
        try container.encode(colorIdentity, forKey: .colorIdentity)
        try container.encode(colors, forKey: .colors)
        try container.encode(convertedManaCost, forKey: .convertedManaCost)
        try container.encode(flavorText, forKey: .flavorText)
        //try container.encode(foreignData, forKey: .foreignData)
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
        //try container.encode(rulings, forKey: .rulings)
        try container.encode(scryfallID, forKey: .scryfallID)
        try container.encode(subtypes, forKey: .subtypes)
        try container.encode(supertypes, forKey: .supertypes)
        try container.encode(tcgplayerProductID, forKey: .tcgplayerProductID)
        try container.encode(tcgplayerPurchaseURL, forKey: .tcgplayerPurchaseURL)
        try container.encode(text, forKey: .text)
        try container.encode(toughness, forKey: .toughness)
        try container.encode(type, forKey: .type)
        try container.encode(types, forKey: .types)
        try container.encode(uuid, forKey: .uuid)
        try container.encode(watermark, forKey: .watermark)
        try container.encode(names, forKey: .names)
        try container.encode(loyalty, forKey: .loyalty)
        try container.encode(faceConvertedManaCost, forKey: .faceConvertedManaCost)
        try container.encode(side, forKey: .side)
        try container.encode(variations, forKey: .variations)
        try container.encode(starter, forKey: .starter)
        
        
    }
    //    init(artist: String?, borderColor: String?, colorIdentity: [String]?, colors: [String]?, convertedManaCost: Int?, flavorText: String?, foreignData: [ForeignDatum]?, frameVersion: String?, hasFoil: Bool?, hasNonFoil: Bool?, layout: String?, legalities: Legalities?, manaCost: String?, multiverseID: Int?, name: String?, number: String?, originalText: String?, originalType: String?, power: String?, printings: [String]?, rarity: String?, rulings: [Ruling]?, scryfallID: String?, subtypes: [String]?, supertypes: [String]?, tcgplayerProductID: Int?, tcgplayerPurchaseURL: String?, text: String?, toughness: String?, type: String?, types: [String]?, uuid: String?, watermark: String?, names: [String]?, loyalty: String?, faceConvertedManaCost: Int?, side: String?, variations: [String]?, starter: Bool?) {
    //        self.artist = artist
    //        self.borderColor = borderColor
    //        self.colorIdentity = colorIdentity
    //        self.colors = colors
    //        self.convertedManaCost = convertedManaCost
    //        self.flavorText = flavorText
    //        self.foreignData = foreignData
    //        self.frameVersion = frameVersion
    //        self.hasFoil = hasFoil
    //        self.hasNonFoil = hasNonFoil
    //        self.layout = layout
    //        self.legalities = legalities
    //        self.manaCost = manaCost
    //        self.multiverseID = multiverseID
    //        self.name = name
    //        self.number = number
    //        self.originalText = originalText
    //        self.originalType = originalType
    //        self.power = power
    //        self.printings = printings
    //        self.rarity = rarity
    //        self.rulings = rulings
    //        self.scryfallID = scryfallID
    //        self.subtypes = subtypes
    //        self.supertypes = supertypes
    //        self.tcgplayerProductID = tcgplayerProductID
    //        self.tcgplayerPurchaseURL = tcgplayerPurchaseURL
    //        self.text = text
    //        self.toughness = toughness
    //        self.type = type
    //        self.types = types
    //        self.uuid = uuid
    //        self.watermark = watermark
    //        self.names = names
    //        self.loyalty = loyalty
    //        self.faceConvertedManaCost = faceConvertedManaCost
    //        self.side = side
    //        self.variations = variations
    //        self.starter = starter
    //    }
}
extension Card {
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
