//
//  CardKeyword+CoreDataProperties.swift
//  MTGCards
//
//  Created by Joseph Smith on 6/17/20.
//  Copyright © 2020 Robotic Snail Software. All rights reserved.
//
//

import Foundation
import CoreData


extension CardKeyword {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CardKeyword> {
        return NSFetchRequest<CardKeyword>(entityName: "CardKeyword")
    }

    @NSManaged public var keyword: String?

}
