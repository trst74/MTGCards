//
//  Meta+CoreDataProperties.swift
//  MTGCards
//
//  Created by Joseph Smith on 4/13/20.
//  Copyright © 2020 Robotic Snail Software. All rights reserved.
//
//

import Foundation
import CoreData


extension Meta {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Meta> {
        return NSFetchRequest<Meta>(entityName: "Meta")
    }

    @NSManaged public var date: String?
    @NSManaged public var version: String?
    @NSManaged public var set: MTGSet?

}
