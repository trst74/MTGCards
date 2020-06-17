//
//  ForeignDatum+CoreDataProperties.swift
//  MTGCards
//
//  Created by Joseph Smith on 4/13/20.
//  Copyright © 2020 Robotic Snail Software. All rights reserved.
//
//

import Foundation
import CoreData


extension ForeignDatum {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ForeignDatum> {
        return NSFetchRequest<ForeignDatum>(entityName: "ForeignDatum")
    }

    @NSManaged public var flavorText: String?
    @NSManaged public var language: String?
    @NSManaged public var multiverseID: Int32
    @NSManaged public var name: String?
    @NSManaged public var text: String?
    @NSManaged public var type: String?
    @NSManaged public var card: Card?

}
