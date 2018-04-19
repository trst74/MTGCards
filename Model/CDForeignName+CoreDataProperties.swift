//
//  CDForeignName+CoreDataProperties.swift
//  MTGCards
//
//  Created by Joseph Smith on 4/3/18.
//  Copyright © 2018 Robotic Snail Software. All rights reserved.
//
//

import Foundation
import CoreData


extension CDForeignName {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDForeignName> {
        return NSFetchRequest<CDForeignName>(entityName: "CDForeignName")
    }

    @NSManaged public var language: String?
    @NSManaged public var multiverseid: Int64
    @NSManaged public var name: String?

}
