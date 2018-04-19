//
//  CDColorIdentity+CoreDataProperties.swift
//  MTGCards
//
//  Created by Joseph Smith on 4/3/18.
//  Copyright © 2018 Robotic Snail Software. All rights reserved.
//
//

import Foundation
import CoreData


extension CDColorIdentity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDColorIdentity> {
        return NSFetchRequest<CDColorIdentity>(entityName: "CDColorIdentity")
    }

    @NSManaged public var colorIdentity: String?

}
