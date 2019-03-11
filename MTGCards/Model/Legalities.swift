//
//  Legalities.swift
//  MTGCards
//
//  Created by Joseph Smith on 1/26/19.
//  Copyright © 2019 Robotic Snail Software. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Legalities: NSManagedObject, Codable {
    @NSManaged var  the1V1: String?
    @NSManaged var  commander: String?
    @NSManaged var  duel: String?
    @NSManaged var  legacy: String?
    @NSManaged var  penny: String?
    @NSManaged var  vintage: String?
    @NSManaged var  frontier: String?
    @NSManaged var  modern: String?
    @NSManaged var  pauper: String?
    @NSManaged var  brawl: String?
    @NSManaged var  future: String?
    @NSManaged var  standard: String?

    enum CodingKeys: String, CodingKey {
        case the1V1 = "1v1"
        case brawl = "brawl"
        case commander = "commander"
        case duel = "duel"
        case frontier = "frontier"
        case future = "future"
        case legacy = "legacy"
        case modern = "modern"
        case pauper = "pauper"
        case penny = "penny"
        case standard = "standard"
        case vintage = "vintage"
    }
    required convenience init(from decoder: Decoder) throws {
        let managedObjectContext = CoreDataStack.handler.privateContext
        guard  let entity = NSEntityDescription.entity(forEntityName: "Legalities", in: managedObjectContext) else {
                fatalError("Failed to decode Legalities")
        }

        self.init(entity: entity, insertInto: managedObjectContext)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.the1V1 = try container.decodeIfPresent(String.self, forKey: .the1V1)
        self.commander = try container.decodeIfPresent(String.self, forKey: .commander)
        self.duel = try container.decodeIfPresent(String.self, forKey: .duel)
        self.legacy = try container.decodeIfPresent(String.self, forKey: .legacy)
        self.penny = try container.decodeIfPresent(String.self, forKey: .penny)
        self.vintage = try container.decodeIfPresent(String.self, forKey: .vintage)
        self.frontier = try container.decodeIfPresent(String.self, forKey: .frontier)
        self.modern = try container.decodeIfPresent(String.self, forKey: .modern)
        self.pauper = try container.decodeIfPresent(String.self, forKey: .pauper)
        self.brawl = try container.decodeIfPresent(String.self, forKey: .brawl)
        self.future = try container.decodeIfPresent(String.self, forKey: .future)
        self.standard = try container.decodeIfPresent(String.self, forKey: .standard)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(the1V1, forKey: .the1V1)
        try container.encode(commander, forKey: .commander)
        try container.encode(duel, forKey: .duel)
        try container.encode(legacy, forKey: .legacy)
        try container.encode(penny, forKey: .penny)
        try container.encode(vintage, forKey: .vintage)
        try container.encode(frontier, forKey: .frontier)
        try container.encode(modern, forKey: .modern)
        try container.encode(pauper, forKey: .pauper)
        try container.encode(brawl, forKey: .brawl)
        try container.encode(future, forKey: .future)
        try container.encode(standard, forKey: .standard)
    }
//    init(the1V1: String?, brawl: String?, commander: String?, duel: String?, frontier: String?, future: String?, legacy: String?, modern: String?, pauper: String?, penny: String?, standard: String?, vintage: String?) {
//        self.the1V1 = the1V1
//        self.brawl = brawl
//        self.commander = commander
//        self.duel = duel
//        self.frontier = frontier
//        self.future = future
//        self.legacy = legacy
//        self.modern = modern
//        self.pauper = pauper
//        self.penny = penny
//        self.standard = standard
//        self.vintage = vintage
//    }
}
