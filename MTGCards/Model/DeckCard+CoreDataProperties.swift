//
//  DeckCard+CoreDataProperties.swift
//  MTGCards
//
//  Created by Joseph Smith on 4/10/20.
//  Copyright © 2020 Robotic Snail Software. All rights reserved.
//
//

import Foundation
import CoreData


extension DeckCard {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DeckCard> {
        return NSFetchRequest<DeckCard>(entityName: "DeckCard")
    }

    @NSManaged public var isCommander: Bool
    @NSManaged public var isFoil: Bool
    @NSManaged public var isSideboard: Bool
    @NSManaged public var quantity: Int16
    @NSManaged var card: Card?
    @NSManaged var deck: Deck?

}
