//
//  Token.swift
//  MTGCards
//
//  Created by Joseph Smith on 1/26/19.
//  Copyright © 2019 Robotic Snail Software. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Token: NSManagedObject, Codable {
    @NSManaged var artist: String?
    @NSManaged var borderColor: String?
    @NSManaged var colorIdentity: [String]?
    @NSManaged var colors: [String]?
    @NSManaged var name: String?
    @NSManaged var number: String?
    @NSManaged var power: String?
    @NSManaged var reverseRelated: [String]?
    @NSManaged var scryfallID: String?
    @NSManaged var text: String?
    @NSManaged var toughness: String?
    @NSManaged var type: String?
    @NSManaged var uuid: String?
    @NSManaged var watermark: String?
    
    enum CodingKeys: String, CodingKey {
        case artist = "artist"
        case borderColor = "borderColor"
        case colorIdentity = "colorIdentity"
        case colors = "colors"
        case name = "name"
        case number = "number"
        case power = "power"
        case reverseRelated = "reverseRelated"
        case scryfallID = "scryfallId"
        case text = "text"
        case toughness = "toughness"
        case type = "type"
        case uuid = "uuid"
        case watermark = "watermark"
    }
    required convenience init(from decoder: Decoder) throws {
        guard let managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext,
            let entity = NSEntityDescription.entity(forEntityName: "Token", in: managedObjectContext) else {
                fatalError("Failed to decode Token")
        }
        
        self.init(entity: entity, insertInto: managedObjectContext)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.artist = try container.decodeIfPresent(String.self, forKey: .artist)
        self.borderColor = try container.decodeIfPresent(String.self, forKey: .borderColor)
        self.colorIdentity = try container.decodeIfPresent([String].self, forKey: .colorIdentity)
        self.colors = try container.decodeIfPresent([String].self, forKey: .colors)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.number = try container.decodeIfPresent(String.self, forKey: .number)
        self.power = try container.decodeIfPresent(String.self, forKey: .power)
        self.reverseRelated = try container.decodeIfPresent([String].self, forKey: .reverseRelated)
        self.scryfallID = try container.decodeIfPresent(String.self, forKey: .scryfallID)
        self.text = try container.decodeIfPresent(String.self, forKey: .text)
        self.toughness = try container.decodeIfPresent(String.self, forKey: .toughness)
        self.type = try container.decodeIfPresent(String.self, forKey: .type)
        self.uuid = try container.decodeIfPresent(String.self, forKey: .uuid)
        self.watermark = try container.decodeIfPresent(String.self, forKey: .watermark)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(artist, forKey: .artist)
        try container.encode(borderColor, forKey: .borderColor)
        try container.encode(colorIdentity, forKey: .colorIdentity)
        try container.encode(colors, forKey: .colors)
        try container.encode(name, forKey: .name)
        try container.encode(number, forKey: .number)
        try container.encode(power, forKey: .power)
        try container.encode(reverseRelated, forKey: .reverseRelated)
        try container.encode(scryfallID, forKey: .scryfallID)
        try container.encode(text, forKey: .text)
        try container.encode(toughness, forKey: .toughness)
        try container.encode(type, forKey: .type)
        try container.encode(uuid, forKey: .uuid)
        try container.encode(watermark, forKey: .watermark)
    }
//    init(artist: String?, borderColor: String?, colorIdentity: [String]?, colors: [String]?, name: String?, number: String?, power: String?, reverseRelated: [String]?, scryfallID: String?, text: String?, toughness: String?, type: String?, uuid: String?, watermark: String?) {
//        self.artist = artist
//        self.borderColor = borderColor
//        self.colorIdentity = colorIdentity
//        self.colors = colors
//        self.name = name
//        self.number = number
//        self.power = power
//        self.reverseRelated = reverseRelated
//        self.scryfallID = scryfallID
//        self.text = text
//        self.toughness = toughness
//        self.type = type
//        self.uuid = uuid
//        self.watermark = watermark
//    }
}
