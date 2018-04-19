//
//  CDSuperType+CoreDataProperties.swift
//  MTGCards
//
//  Created by Joseph Smith on 4/3/18.
//  Copyright © 2018 Robotic Snail Software. All rights reserved.
//
//

import Foundation
import CoreData


extension CDSuperType {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDSuperType> {
        return NSFetchRequest<CDSuperType>(entityName: "CDSuperType")
    }

    @NSManaged public var supertype: String?

}
