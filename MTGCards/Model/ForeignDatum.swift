//
//  ForeignDatum.swift
//  MTGCards
//
//  Created by Joseph Smith on 1/26/19.
//  Copyright © 2019 Robotic Snail Software. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class ForeignDatum: NSManagedObject, Codable {
    @NSManaged var flavorText: String?
    @NSManaged var language: String?
    @NSManaged var multiverseID: Int32
    @NSManaged var name: String?
    @NSManaged var text: String?
    @NSManaged var type: String?
    @NSManaged var card: Card

    enum CodingKeys: String, CodingKey {
        case flavorText = "flavorText"
        case language = "language"
        case multiverseID = "multiverseId"
        case name = "name"
        case text = "text"
        case type = "type"
    }
    required convenience init(from decoder: Decoder) throws {
//        let managedObjectContext = CoreDataStack.handler.privateContext
//        guard let entity = NSEntityDescription.entity(forEntityName: "ForeignDatum", in: managedObjectContext) else {
//                fatalError("Failed to decode ForeignDatum")
//        }
        guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext,
            let managedObjectContext = decoder.userInfo[codingUserInfoKeyManagedObjectContext] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "ForeignDatum", in: managedObjectContext) else {
                fatalError("Failed to decode User")
        }
        self.init(entity: entity, insertInto: managedObjectContext)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.flavorText = try container.decodeIfPresent(String.self, forKey: .flavorText)
        self.language = try container.decodeIfPresent(String.self, forKey: .language)
        if let mvid = try container.decodeIfPresent(Int32.self, forKey: .multiverseID) {
            self.multiverseID = mvid
        }
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.text = try container.decodeIfPresent(String.self, forKey: .text)
        self.type = try container.decodeIfPresent(String.self, forKey: .type)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(flavorText, forKey: .flavorText)
        try container.encode(language, forKey: .language)
        try container.encode(multiverseID, forKey: .multiverseID)
        try container.encode(name, forKey: .name)
        try container.encode(text, forKey: .text)
        try container.encode(type, forKey: .type)
    }
    //    init(flavorText: String?, language: String?, multiverseID: Int?, name: String?, text: String?, type: String?) {
    //        self.flavorText = flavorText
    //        self.language = language
    //        self.multiverseID = multiverseID
    //        self.name = name
    //        self.text = text
    //        self.type = type
    //    }
}
