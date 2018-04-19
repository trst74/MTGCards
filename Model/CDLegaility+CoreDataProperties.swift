//
//  CDLegaility+CoreDataProperties.swift
//  MTGCards
//
//  Created by Joseph Smith on 4/3/18.
//  Copyright © 2018 Robotic Snail Software. All rights reserved.
//
//

import Foundation
import CoreData


extension CDLegaility {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDLegaility> {
        return NSFetchRequest<CDLegaility>(entityName: "CDLegaility")
    }

    @NSManaged public var format: String?
    @NSManaged public var legality: String?

}
