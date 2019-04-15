//
//  DeckCard+CoreDataProperties.swift
//  MTGCards
//
//  Created by Joseph Smith on 4/15/19.
//  Copyright © 2019 Robotic Snail Software. All rights reserved.
//
//

import Foundation
import CoreData


extension DeckCard {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DeckCard> {
        return NSFetchRequest<DeckCard>(entityName: "DeckCard")
    }

    @NSManaged public var isSideboard: Bool
    @NSManaged public var quantity: Int16
    @NSManaged public var isCommander: Bool
    @NSManaged  var card: Card?

}
