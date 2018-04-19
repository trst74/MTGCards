//
//  CDCard+Custom.swift
//  MTGCards
//
//  Created by Joseph Smith on 3/15/18.
//  Copyright © 2018 Robotic Snail Software. All rights reserved.
//

import Foundation
import CoreData

extension CDCard{
    convenience init(from source: Card, inContext context: NSManagedObjectContext){
        self.init(context: context)
        self.artist = source.artist
        self.cmc = source.cmc!
        if let cis = source.colorIdentity {
            for ci in cis {
                self.addToColorIdentity(CDColorIdentity.init(from: ci, inContext: context))
            }
        }
        self.id = source.id
        self.imageName = source.imageName
        self.layout = source.layout
        self.manaCost = source.manaCost
        if let mvid = source.multiverseid {
            self.multiverseid = Int64(mvid)
        }
        self.name = source.name
        self.number  = source.number
        self.mciNumber = source.mciNumber
        self.originalText = source.originalText
        self.originalType = source.originalType
        if let printings = source.printings {
            for p in printings {
                self.addToPrintings(CDPrinting.init(from: p, inContext: context))
            }
        }
        self.rarity = source.rarity
        if let rulings = source.rulings {
            for r in rulings {
                self.addToRulings(CDRuling.init(from: r, inContext: context))
            }
        }
        self.text = source.text
        self.type = source.type
        if let types = source.types {
            for t in types {
                self.addToTypes(CDType.init(from: t, inContext: context))
            }
        }
        self.power = source.power
        if let subtypes = source.subtypes {
            for t in subtypes {
                self.addToSubtypes(CDSubType.init(from: t, inContext: context))
            }
        }
        self.toughness = source.toughness
        self.flavor = source.flavor
        //legalities
        if let legalities = source.legalities {
            for l in legalities {
                self.addToLegalities(CDLegaility.init(from: l, inContext: context))
            }
        }
        if let supertypes = source.supertypes {
            for t in supertypes {
                self.addToSupertypes(CDSuperType.init(from: t, inContext: context))
            }
        }
        if let l = source.loyalty{
            self.loyalty = Int64(l)
        }
        if let names = source.names {
            for n in names {
                self.addToNames(CDName.init(from: n, inContext: context))
            }
        }
        self.watermark = source.watermark
        
    }
}
