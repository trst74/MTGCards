//
//  ColorIdentity+CoreDataProperties.swift
//  MTGCards
//
//  Created by Joseph Smith on 4/8/19.
//  Copyright © 2019 Robotic Snail Software. All rights reserved.
//
//

import Foundation
import CoreData


extension ColorIdentity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ColorIdentity> {
        return NSFetchRequest<ColorIdentity>(entityName: "ColorIdentity")
    }

    @NSManaged public var color: String?
    @NSManaged  var card: Card?

}
