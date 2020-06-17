//
//  Token+CoreDataProperties.swift
//  MTGCards
//
//  Created by Joseph Smith on 4/13/20.
//  Copyright © 2020 Robotic Snail Software. All rights reserved.
//
//

import Foundation
import CoreData


extension Token {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Token> {
        return NSFetchRequest<Token>(entityName: "Token")
    }

    @NSManaged public var artist: String?
    @NSManaged public var borderColor: String?
    @NSManaged public var colorIdentity: NSObject?
    @NSManaged public var colors: NSObject?
    @NSManaged public var name: String?
    @NSManaged public var number: String?
    @NSManaged public var power: String?
    @NSManaged public var reverseRelated: NSObject?
    @NSManaged public var scryfallID: String?
    @NSManaged public var text: String?
    @NSManaged public var toughness: String?
    @NSManaged public var type: String?
    @NSManaged public var uuid: String?
    @NSManaged public var watermark: String?
    @NSManaged public var set: MTGSet?

}
