//
//  CDRuling+CoreDataProperties.swift
//  MTGCards
//
//  Created by Joseph Smith on 4/3/18.
//  Copyright © 2018 Robotic Snail Software. All rights reserved.
//
//

import Foundation
import CoreData


extension CDRuling {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDRuling> {
        return NSFetchRequest<CDRuling>(entityName: "CDRuling")
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var text: String?

}
