//
//  Meta.swift
//  MTGCards
//
//  Created by Joseph Smith on 1/26/19.
//  Copyright © 2019 Robotic Snail Software. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Meta: NSManagedObject, Codable {
    @NSManaged var date: String?
    @NSManaged var version: String?

    enum CodingKeys: String, CodingKey {
        case date = "date"
        case version = "version"
    }
    required convenience init(from decoder: Decoder) throws {
//        let managedObjectContext = CoreDataStack.handler.privateContext
//        guard let entity = NSEntityDescription.entity(forEntityName: "Meta", in: managedObjectContext) else {
//                fatalError("Failed to decode Meta")
//        }
        guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext,
            let managedObjectContext = decoder.userInfo[codingUserInfoKeyManagedObjectContext] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "Meta", in: managedObjectContext) else {
                fatalError("Failed to decode User")
        }
        self.init(entity: entity, insertInto: managedObjectContext)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.date = try container.decodeIfPresent(String.self, forKey: .date)
        self.version = try container.decodeIfPresent(String.self, forKey: .version)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(date, forKey: .date)
        try container.encode(version, forKey: .version)
    }
    //    init(date: String?, version: String?) {
    //        self.date = date
    //        self.version = version
    //    }
}
