//
//  CDSubType+CoreDataProperties.swift
//  MTGCards
//
//  Created by Joseph Smith on 4/3/18.
//  Copyright © 2018 Robotic Snail Software. All rights reserved.
//
//

import Foundation
import CoreData


extension CDSubType {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDSubType> {
        return NSFetchRequest<CDSubType>(entityName: "CDSubType")
    }

    @NSManaged public var subtype: String?

}
