//
//  CDName+CoreDataProperties.swift
//  MTGCards
//
//  Created by Joseph Smith on 4/3/18.
//  Copyright © 2018 Robotic Snail Software. All rights reserved.
//
//

import Foundation
import CoreData


extension CDName {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDName> {
        return NSFetchRequest<CDName>(entityName: "CDName")
    }

    @NSManaged public var name: String?

}
