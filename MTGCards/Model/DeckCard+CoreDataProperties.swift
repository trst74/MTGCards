//
//  DeckCard+CoreDataProperties.swift
//  MTGCards
//
//  Created by Joseph Smith on 3/14/19.
//  Copyright © 2019 Robotic Snail Software. All rights reserved.
//
//

import Foundation
import CoreData


extension DeckCard {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DeckCard> {
        return NSFetchRequest<DeckCard>(entityName: "DeckCard")
    }

    @NSManaged public var condition: String?
    @NSManaged public var quantity: Int16
    @NSManaged  var card: Card?

}
