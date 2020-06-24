//
//  CardFrameEffect+CoreDataProperties.swift
//  MTGCards
//
//  Created by Joseph Smith on 6/19/20.
//  Copyright © 2020 Robotic Snail Software. All rights reserved.
//
//

import Foundation
import CoreData


extension CardFrameEffect {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CardFrameEffect> {
        return NSFetchRequest<CardFrameEffect>(entityName: "CardFrameEffect")
    }

    @NSManaged public var effect: String?

}
