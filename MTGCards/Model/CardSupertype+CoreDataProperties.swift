//
//  CardSupertype+CoreDataProperties.swift
//  MTGCards
//
//  Created by Joseph Smith on 4/8/19.
//  Copyright © 2019 Robotic Snail Software. All rights reserved.
//
//

import Foundation
import CoreData


extension CardSupertype {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CardSupertype> {
        return NSFetchRequest<CardSupertype>(entityName: "CardSupertype")
    }

    @NSManaged public var supertype: String?
    @NSManaged var card: Card?

}
