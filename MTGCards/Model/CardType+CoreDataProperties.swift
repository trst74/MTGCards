//
//  CardType+CoreDataProperties.swift
//  MTGCards
//
//  Created by Joseph Smith on 4/7/19.
//  Copyright © 2019 Robotic Snail Software. All rights reserved.
//
//

import Foundation
import CoreData


extension CardType {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CardType> {
        return NSFetchRequest<CardType>(entityName: "CardType")
    }

    @NSManaged public var type: String?
    @NSManaged  var card: Card?

}
