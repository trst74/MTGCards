//
//  CDType+CoreDataProperties.swift
//  MTGCards
//
//  Created by Joseph Smith on 4/3/18.
//  Copyright © 2018 Robotic Snail Software. All rights reserved.
//
//

import Foundation
import CoreData


extension CDType {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDType> {
        return NSFetchRequest<CDType>(entityName: "CDType")
    }

    @NSManaged public var type: String?

}
