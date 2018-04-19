//
//  CDColor+CoreDataProperties.swift
//  MTGCards
//
//  Created by Joseph Smith on 4/3/18.
//  Copyright © 2018 Robotic Snail Software. All rights reserved.
//
//

import Foundation
import CoreData


extension CDColor {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDColor> {
        return NSFetchRequest<CDColor>(entityName: "CDColor")
    }

    @NSManaged public var color: String?

}
