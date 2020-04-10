//
//  CollectionCard+CoreDataProperties.swift
//  MTGCards
//
//  Created by Joseph Smith on 4/10/20.
//  Copyright © 2020 Robotic Snail Software. All rights reserved.
//
//

import Foundation
import CoreData


extension CollectionCard {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CollectionCard> {
        return NSFetchRequest<CollectionCard>(entityName: "CollectionCard")
    }

    @NSManaged public var condition: String?
    @NSManaged public var isFoil: Bool
    @NSManaged public var quantity: Int16
    @NSManaged var card: Card?
    @NSManaged var collection: Collection?

}
