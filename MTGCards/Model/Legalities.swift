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
    public func getLegalitiesCollection() -> [Legality] {
        var results: [Legality] = []
        if let the1v1 = the1V1 {
            results.append(Legality(format: "the1v1", legality: the1v1))
        }
        if let commander = commander {
            results.append(Legality(format: "Commander", legality: commander))
        }
        if let duel = duel {
            results.append(Legality(format: "Duel", legality: duel))
        }
        if let legacy = legacy {
            results.append(Legality(format: "Legacy", legality: legacy))
        }
        if let penny = penny {
            results.append(Legality(format: "Penny", legality: penny))
        }
        if let vintage = vintage {
            results.append(Legality(format: "Vintage", legality: vintage))
        }
        if let frontier = frontier {
            results.append(Legality(format: "Frontier", legality: frontier))
        }
        if let modern = modern {
            results.append(Legality(format: "Modern", legality: modern))
        }
        if let pauper = pauper {
            results.append(Legality(format: "Pauper", legality: pauper))
        }
        if let brawl = brawl {
            results.append(Legality(format: "Brawl", legality: brawl))
        }
        if let future = future {
            results.append(Legality(format: "Future", legality: future))
        }
        if let standard = standard {
            results.append(Legality(format: "Standard", legality: standard))
        }
        return results
    }
}
public struct Legality {
    var format: String
    var legality: String
}
