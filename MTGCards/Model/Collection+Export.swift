//
//  Collection+Export.swift
//  MTGCards
//
//  Created by Joseph Smith on 4/30/19.
//  Copyright © 2019 Robotic Snail Software. All rights reserved.
//

import Foundation
import CoreData


extension Collection {
    func exportToJson() -> String? {
        var cardStrings: [String] = []
        if let cards = cards?.allObjects as? [CollectionCard]{
            for card in cards {
                if let uuid = card.card?.uuid {
                    cardStrings.append(uuid)
                }
            }
        }
        guard let data = try? JSONSerialization.data(withJSONObject: cardStrings, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
}
