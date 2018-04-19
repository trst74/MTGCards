//
//  Filters.swift
//  MTGCards
//
//  Created by Joseph Smith on 3/29/18.
//  Copyright © 2018 Robotic Snail Software. All rights reserved.
//

import Foundation

class Filters {
    var colorIdentities = Set<String>()
    var castingCost: Double = 0.0
    var name = ""
    var types: [String] = []
    var subTypes: [String] = []
    var superTypes: [String] = []
    var legalities: [String] = []
    var sets: [String] = []
    
    func GetPredicates() -> [NSPredicate] {
        var predicates: [NSPredicate] = []
        
        //name from previous screen
        if name != "" {
            let namePredicate = NSPredicate(format: "name contains[c] %@", name)
            predicates.append(namePredicate)
        }
        
        //color identities
        if (colorIdentities.count) > 0 {
            let colorIdentitisPredicate = NSPredicate(format: "ANY colorIdentity.colorIdentity  in %@", (colorIdentities))
            if colorIdentities.contains("C") {
                let colorlessPredicate = NSPredicate(format: "colorIdentity.@count == 0")
                let compoundColorPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: [colorIdentitisPredicate, colorlessPredicate])
                predicates.append(compoundColorPredicate)
            } else {
                predicates.append(colorIdentitisPredicate)
            }
        }
        
        //types
        if (types.count) > 0 {
            let typesPredicate = NSPredicate(format: "ANY types.type  in %@", (types))
            predicates.append(typesPredicate)
        }
        //legalities
        if (legalities.count) > 0 {
            let legalitiesPredicate = NSPredicate(format: "SUBQUERY(legalities,$l, $l.legality == %@  AND $l.format IN %@).@count > 0", "Legal",(legalities))
            predicates.append(legalitiesPredicate)
        }
        //super types
        if (superTypes.count) > 0 {
            let superTypesPredicate = NSPredicate(format: "ANY supertypes.supertype  in %@", (superTypes))
            predicates.append(superTypesPredicate)
        }
        //sub types
        if (subTypes.count) > 0 {
            let subTypesPredicate = NSPredicate(format: "ANY subtypes.subtype  in %@", (subTypes))
            predicates.append(subTypesPredicate)
        }
        //sets
        if sets.count > 0 {
            let setsPredicate = NSPredicate(format: "set.name in %@", sets)
            predicates.append(setsPredicate)
        }
        return predicates
    }
}
