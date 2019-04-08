//
//  CardSubtype+CoreDataProperties.swift
//  MTGCards
//
//  Created by Joseph Smith on 4/8/19.
//  Copyright © 2019 Robotic Snail Software. All rights reserved.
//
//

import Foundation
import CoreData


extension CardSubtype {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CardSubtype> {
        return NSFetchRequest<CardSubtype>(entityName: "CardSubtype")
    }

    @NSManaged public var subtype: String?
    @NSManaged var card: Card?

}
