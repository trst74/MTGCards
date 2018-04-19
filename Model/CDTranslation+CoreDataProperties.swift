//
//  CDTranslation+CoreDataProperties.swift
//  MTGCards
//
//  Created by Joseph Smith on 4/3/18.
//  Copyright © 2018 Robotic Snail Software. All rights reserved.
//
//

import Foundation
import CoreData


extension CDTranslation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDTranslation> {
        return NSFetchRequest<CDTranslation>(entityName: "CDTranslation")
    }

    @NSManaged public var de: String?
    @NSManaged public var es: String?
    @NSManaged public var fr: String?
    @NSManaged public var it: String?
    @NSManaged public var pt: String?
    @NSManaged public var ru: String?

}
