//
//  CDSet+Custom.swift
//  MTGCards
//
//  Created by Joseph Smith on 3/15/18.
//  Copyright © 2018 Robotic Snail Software. All rights reserved.
//

import Foundation
import CoreData

extension CDMTGSet{

    convenience init(from source: MTGSet, inContext context: NSManagedObjectContext){
        self.init(context: context)
        self.name = source.name
        self.code = source.code
        self.magicCardsInfoCode = source.magicCardsInfoCode
        self.releaseDate = source.releaseDate
        self.border = source.border
        self.type = source.type
        self.block = source.block
        if let t = source.translations{
            self.translations = CDTranslation.init(from: t, inContext: context)
        }
        self.mkmName = source.mkmName
        if let mkmID = source.mkmID {
                 self.mkmID = mkmID
        }
   
        
        //cards
        for card in source.cards! {
            self.addToCards(CDCard.init(from: card, inContext: context))
        }
    }
}
