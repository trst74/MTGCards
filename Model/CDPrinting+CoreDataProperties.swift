//
//  CDPrinting+CoreDataProperties.swift
//  MTGCards
//
//  Created by Joseph Smith on 4/3/18.
//  Copyright © 2018 Robotic Snail Software. All rights reserved.
//
//

import Foundation
import CoreData


extension CDPrinting {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDPrinting> {
        return NSFetchRequest<CDPrinting>(entityName: "CDPrinting")
    }

    @NSManaged public var printing: String?

}
